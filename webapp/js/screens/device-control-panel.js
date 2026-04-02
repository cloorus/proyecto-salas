// Device Control Panel Screen Module (Enhanced)
const DeviceControlPanelScreen = {
    currentDevice: null,
    deviceActions: [],
    deviceStatus: 'Cerrado',
    autoCloseTimer: null,
    countdownSeconds: 0,

    async render(deviceId) {
        if (!deviceId) {
            return this.renderError('ID de dispositivo no proporcionado');
        }

        try {
            App.showLoading();

            // Fetch device details and actions
            const [deviceResult, actionsResult] = await Promise.all([
                API.getDeviceDetail(deviceId),
                API.getDeviceActions(deviceId)
            ]);

            App.hideLoading();

            if (!deviceResult.success) {
                return this.renderError(deviceResult.error || 'Error cargando dispositivo');
            }

            this.currentDevice = deviceResult.data;
            this.deviceActions = actionsResult.success ? (actionsResult.data || []) : [];
            this.deviceStatus = this.getDeviceStatus();

            return `
                <div class="device-control-panel-container">
                    ${this.renderHeader()}
                    ${this.renderDeviceImage()}
                    ${this.renderControlButtons()}
                    ${this.renderStatusSection()}
                    ${this.renderLampControl()}
                </div>
            `;
        } catch (error) {
            console.error('Error rendering device control panel:', error);
            App.hideLoading();
            return this.renderError('Error cargando panel de control');
        }
    },

    renderHeader() {
        return `
            <div class="header">
                <button class="header-back material-icons" onclick="App.goBack()">
                    arrow_back
                </button>
                <h1 class="header-title" style="color: var(--title-blue); font-family: 'Montserrat', sans-serif;">${this.currentDevice?.name || 'Control Panel'}</h1>
                <button class="header-back material-icons" onclick="DeviceControlPanelScreen.showDeviceInfo()" title="Información">
                    info
                </button>
            </div>
        `;
    },

    renderDeviceImage() {
        return `
            <div class="device-image-section" style="padding: 24px 16px; text-align: center; background: linear-gradient(135deg, #f8f9fa, #e9ecef);">
                <div class="device-image-container" style="position: relative; display: inline-block;">
                    <div class="device-image" style="width: 200px; height: 150px; background-color: #f0f0f0; border-radius: 12px; display: flex; align-items: center; justify-content: center; border: 2px solid var(--divider-color); box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
                        <span class="material-icons" style="font-size: 64px; color: var(--primary-purple);">${App.getDeviceIcon(this.currentDevice?.device_type)}</span>
                    </div>
                    <div class="device-status-indicator" style="position: absolute; top: -8px; right: -8px; width: 24px; height: 24px; border-radius: 50%; background-color: ${this.currentDevice?.is_online ? 'var(--success-color)' : 'var(--text-hint)'}; border: 3px solid white; box-shadow: 0 2px 4px rgba(0,0,0,0.2);"></div>
                </div>
                <h2 style="color: var(--text-primary); margin-top: 16px; font-family: 'Montserrat', sans-serif; font-weight: 600;">${this.currentDevice?.name || 'Dispositivo'}</h2>
                <p style="color: var(--text-secondary); margin-top: 4px;">${this.currentDevice?.location || 'Sin ubicación'}</p>
            </div>
        `;
    },

    renderControlButtons() {
        const isOnline = this.currentDevice?.is_online;
        
        return `
            <div class="control-panel">
                <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 24px; text-align: center; font-family: 'Montserrat', sans-serif;">
                    <span class="material-icons" style="vertical-align: middle; margin-right: 8px;">touch_app</span>
                    Controles
                </h3>
                
                <div class="control-buttons">
                    <button 
                        class="circular-btn abrir ${!isOnline ? 'disabled' : ''}" 
                        onclick="DeviceControlPanelScreen.executeCommand('OPEN')"
                        ${!isOnline ? 'disabled' : ''}
                        title="${!isOnline ? 'Dispositivo desconectado' : 'Abrir'}"
                    >
                        <span class="material-icons">sensor_door</span>
                        <span class="btn-label">ABRIR</span>
                    </button>
                    
                    <button 
                        class="circular-btn pausa ${!isOnline ? 'disabled' : ''}" 
                        onclick="DeviceControlPanelScreen.executeCommand('STOP')"
                        ${!isOnline ? 'disabled' : ''}
                        title="${!isOnline ? 'Dispositivo desconectado' : 'Pausa'}"
                    >
                        <span class="material-icons">pause</span>
                        <span class="btn-label">PAUSA</span>
                    </button>
                    
                    <button 
                        class="circular-btn cerrar ${!isOnline ? 'disabled' : ''}" 
                        onclick="DeviceControlPanelScreen.executeCommand('CLOSE')"
                        ${!isOnline ? 'disabled' : ''}
                        title="${!isOnline ? 'Dispositivo desconectado' : 'Cerrar'}"
                    >
                        <span class="material-icons">door_front</span>
                        <span class="btn-label">CERRAR</span>
                    </button>
                    
                    <button 
                        class="circular-btn peatonal ${!isOnline ? 'disabled' : ''}" 
                        onclick="DeviceControlPanelScreen.executeCommand('PEDESTRIAN')"
                        ${!isOnline ? 'disabled' : ''}
                        title="${!isOnline ? 'Dispositivo desconectado' : 'Peatonal'}"
                    >
                        <span class="material-icons">directions_walk</span>
                        <span class="btn-label">PEATONAL</span>
                    </button>
                </div>
            </div>
        `;
    },

    renderStatusSection() {
        return `
            <div class="device-status-section">
                <div class="status-title">Estado Actual</div>
                <div class="status-value" id="deviceStatus">${this.deviceStatus}</div>
                
                <div class="auto-close-section" id="autoCloseSection" style="margin-top: 16px; ${this.countdownSeconds > 0 ? '' : 'display: none;'}">
                    <div style="display: flex; align-items: center; gap: 8px; color: var(--warning-color);">
                        <span class="material-icons">schedule</span>
                        <span>Cierre automático:</span>
                        <span id="countdownTimer" style="font-weight: 600;">${this.countdownSeconds}s</span>
                    </div>
                    
                    <div class="countdown-bar" style="width: 100%; height: 4px; background-color: var(--divider-color); border-radius: 2px; margin-top: 8px; overflow: hidden;">
                        <div id="countdownProgress" style="height: 100%; background-color: var(--warning-color); border-radius: 2px; transition: width 1s linear; width: 100%;"></div>
                    </div>
                </div>
                
                <div class="quick-actions" style="margin-top: 24px; display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <button class="btn btn-secondary" onclick="DeviceControlPanelScreen.setAutoCloseTimer(20)">
                        <span class="material-icons">timer</span>
                        20s
                    </button>
                    <button class="btn btn-secondary" onclick="DeviceControlPanelScreen.cancelAutoClose()">
                        <span class="material-icons">cancel</span>
                        Cancelar
                    </button>
                </div>
            </div>
        `;
    },

    renderLampControl() {
        return `
            <div class="device-status-section">
                <div class="status-title">Control de Lámpara</div>
                
                <div style="display: flex; align-items: center; justify-content: space-between; margin-top: 16px;">
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <span class="material-icons" style="color: var(--primary-purple); font-size: 24px;">lightbulb</span>
                        <span style="font-weight: 500;">Lámpara LED</span>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" id="lampToggle" onchange="DeviceControlPanelScreen.toggleLamp(this.checked)">
                        <span class="toggle-slider"></span>
                    </label>
                </div>
                
                <div style="display: flex; align-items: center; gap: 12px; margin-top: 16px; color: var(--text-secondary); font-size: 14px;">
                    <span class="material-icons" style="font-size: 16px;">info</span>
                    <span>La lámpara se enciende automáticamente durante la operación</span>
                </div>
            </div>
        `;
    },

    renderError(errorMessage) {
        return `
            <div class="device-control-panel-container">
                <div class="header">
                    <button class="header-back material-icons" onclick="App.goBack()">
                        arrow_back
                    </button>
                    <h1 class="header-title">Error</h1>
                </div>
                <div class="form-container">
                    <div class="text-center" style="padding: 48px 24px;">
                        <span class="material-icons" style="font-size: 64px; color: var(--error-color); margin-bottom: 16px;">error</span>
                        <h3 style="color: var(--error-color); margin-bottom: 8px;">Error</h3>
                        <p style="color: var(--text-secondary); margin-bottom: 24px;">${errorMessage}</p>
                        <button class="btn btn-primary" onclick="App.goBack()">
                            <span class="material-icons">arrow_back</span>
                            Volver
                        </button>
                    </div>
                </div>
            </div>
        `;
    },

    // Initialize control panel screen events after render
    init() {
        // Add tactile feedback for circular buttons
        const circularBtns = document.querySelectorAll('.circular-btn:not(.disabled)');
        circularBtns.forEach(btn => {
            btn.addEventListener('touchstart', () => {
                btn.style.transform = 'scale(0.95)';
            });
            
            btn.addEventListener('touchend', () => {
                btn.style.transform = 'scale(1)';
            });
            
            btn.addEventListener('mousedown', () => {
                btn.style.transform = 'scale(0.95)';
            });
            
            btn.addEventListener('mouseup', () => {
                btn.style.transform = 'scale(1)';
            });
        });
    },

    // Control methods
    async executeCommand(command) {
        if (!this.currentDevice?.is_online) {
            App.showToast('Dispositivo desconectado', 'error');
            return;
        }

        const button = document.querySelector(`[onclick*="${command}"]`);
        if (button) {
            this.setButtonLoadingState(button, true);
        }

        try {
            const result = await API.sendCommand(this.currentDevice.id, command);
            
            if (result.success) {
                this.updateDeviceStatus(command);
                App.showToast(`Comando ${command} ejecutado`, 'success');
                
                // Start auto-close timer for OPEN command
                if (command === 'OPEN') {
                    this.setAutoCloseTimer(20);
                }
            } else {
                App.showToast(`Error: ${result.error}`, 'error');
            }
            
        } catch (error) {
            console.error('Command execution error:', error);
            App.showToast('Error ejecutando comando', 'error');
        } finally {
            if (button) {
                this.setButtonLoadingState(button, false);
            }
        }
    },

    updateDeviceStatus(command) {
        const statusMap = {
            'OPEN': 'Abierto',
            'CLOSE': 'Cerrado', 
            'STOP': 'Detenido',
            'PEDESTRIAN': 'Modo Peatonal'
        };
        
        this.deviceStatus = statusMap[command] || 'Desconocido';
        const statusElement = document.getElementById('deviceStatus');
        if (statusElement) {
            statusElement.textContent = this.deviceStatus;
            statusElement.style.color = command === 'OPEN' ? 'var(--success-color)' : 
                                      command === 'CLOSE' ? 'var(--text-primary)' : 
                                      'var(--warning-color)';
        }
    },

    setAutoCloseTimer(seconds) {
        // Clear existing timer
        this.cancelAutoClose();
        
        this.countdownSeconds = seconds;
        const section = document.getElementById('autoCloseSection');
        const timer = document.getElementById('countdownTimer');
        const progress = document.getElementById('countdownProgress');
        
        if (section) section.style.display = 'block';
        
        this.autoCloseTimer = setInterval(() => {
            this.countdownSeconds--;
            
            if (timer) timer.textContent = `${this.countdownSeconds}s`;
            if (progress) {
                const percentage = (this.countdownSeconds / seconds) * 100;
                progress.style.width = `${percentage}%`;
            }
            
            if (this.countdownSeconds <= 0) {
                this.autoClose();
            }
        }, 1000);
    },

    cancelAutoClose() {
        if (this.autoCloseTimer) {
            clearInterval(this.autoCloseTimer);
            this.autoCloseTimer = null;
        }
        
        this.countdownSeconds = 0;
        const section = document.getElementById('autoCloseSection');
        if (section) section.style.display = 'none';
    },

    async autoClose() {
        this.cancelAutoClose();
        App.showToast('Cerrando automáticamente...', 'info');
        await this.executeCommand('CLOSE');
    },

    async toggleLamp(isOn) {
        if (!this.currentDevice?.is_online) {
            App.showToast('Dispositivo desconectado', 'error');
            // Reset toggle
            const toggle = document.getElementById('lampToggle');
            if (toggle) toggle.checked = !isOn;
            return;
        }

        try {
            const command = isOn ? 'LAMP_ON' : 'LAMP_OFF';
            const result = await API.sendCommand(this.currentDevice.id, command);
            
            if (result.success) {
                App.showToast(`Lámpara ${isOn ? 'encendida' : 'apagada'}`, 'success');
            } else {
                // Reset toggle on error
                const toggle = document.getElementById('lampToggle');
                if (toggle) toggle.checked = !isOn;
                App.showToast('Error controlando lámpara', 'error');
            }
            
        } catch (error) {
            console.error('Lamp toggle error:', error);
            const toggle = document.getElementById('lampToggle');
            if (toggle) toggle.checked = !isOn;
            App.showToast('Error controlando lámpara', 'error');
        }
    },

    showDeviceInfo() {
        App.navigate(`#/devices/${this.currentDevice.id}/info`);
    },

    getDeviceStatus() {
        // This could be determined from device state or last command
        return this.currentDevice?.is_online ? 'En línea' : 'Desconectado';
    },

    setButtonLoadingState(button, loading) {
        if (!button) return;

        const icon = button.querySelector('.material-icons');
        const label = button.querySelector('.btn-label');
        
        if (loading) {
            button.disabled = true;
            button.style.opacity = '0.7';
            if (icon) icon.textContent = 'hourglass_empty';
            if (label) label.textContent = 'ENVIANDO...';
        } else {
            button.disabled = false;
            button.style.opacity = '1';
            
            // Restore original content based on onclick
            const onclick = button.getAttribute('onclick');
            if (onclick?.includes('OPEN')) {
                if (icon) icon.textContent = 'sensor_door';
                if (label) label.textContent = 'ABRIR';
            } else if (onclick?.includes('CLOSE')) {
                if (icon) icon.textContent = 'door_front';
                if (label) label.textContent = 'CERRAR';
            } else if (onclick?.includes('STOP')) {
                if (icon) icon.textContent = 'pause';
                if (label) label.textContent = 'PAUSA';
            } else if (onclick?.includes('PEDESTRIAN')) {
                if (icon) icon.textContent = 'directions_walk';
                if (label) label.textContent = 'PEATONAL';
            }
        }
    },

    // Cleanup when leaving screen
    destroy() {
        this.cancelAutoClose();
    }
};

// Auto-initialize when content is rendered
document.addEventListener('DOMContentLoaded', () => {
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.addedNodes) {
                mutation.addedNodes.forEach((node) => {
                    if (node.nodeType === Node.ELEMENT_NODE) {
                        const controlContainer = node.querySelector('.device-control-panel-container') || 
                                               (node.classList && node.classList.contains('device-control-panel-container') ? node : null);
                        if (controlContainer) {
                            setTimeout(() => DeviceControlPanelScreen.init(), 0);
                        }
                    }
                });
            }
        });
    });

    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
});

window.DeviceControlPanelScreen = DeviceControlPanelScreen;