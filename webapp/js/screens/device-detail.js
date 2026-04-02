// Device Detail Screen Module
const DeviceDetailScreen = {
    currentDevice: null,
    deviceActions: [],

    async render(deviceId) {
        if (!deviceId) {
            return this.renderError('ID de dispositivo no proporcionado');
        }

        try {
            App.showLoading();

            // Fetch device details and actions in parallel
            const [deviceResult, actionsResult] = await Promise.all([
                API.getDeviceDetail(deviceId),
                API.getDeviceActions(deviceId)
            ]);

            App.hideLoading();

            if (!deviceResult.success) {
                return this.renderError(deviceResult.error || 'Error cargando dispositivo');
            }

            if (!actionsResult.success) {
                console.warn('Error loading device actions:', actionsResult.error);
                this.deviceActions = [];
            } else {
                // Actions endpoint returns array directly
                this.deviceActions = Array.isArray(actionsResult.data) ? actionsResult.data : [];
            }

            // Handle /full endpoint response format: {device: {...}, parameters: {...}, status: {...}, users: [...], recent_events: [...]}
            if (deviceResult.data && deviceResult.data.device) {
                this.currentDevice = {
                    ...deviceResult.data.device,
                    // Merge additional data from full response
                    parameters: deviceResult.data.parameters || {},
                    status: deviceResult.data.status || {},
                    users: deviceResult.data.users || [],
                    recent_events: deviceResult.data.recent_events || []
                };
            } else {
                // Fallback for simple device endpoint
                this.currentDevice = deviceResult.data;
            }

            return `
                <div class="device-detail-container">
                    ${this.renderHeader()}
                    ${this.renderDeviceInfo()}
                    ${this.renderActions()}
                </div>
            `;
        } catch (error) {
            console.error('Error rendering device detail:', error);
            App.hideLoading();
            return this.renderError('Error cargando detalles del dispositivo');
        }
    },

    renderHeader() {
        return `
            <div class="header">
                <button class="header-back material-icons" onclick="App.goBack()">
                    arrow_back
                </button>
                <h1 class="header-title">${this.currentDevice?.name || 'Dispositivo'}</h1>
            </div>
        `;
    },

    renderDeviceInfo() {
        const device = this.currentDevice;
        if (!device) return '';

        const deviceType = App.formatDeviceType(device.type || 'device');
        const statusText = App.formatDeviceStatus(device.is_online);
        const statusClass = device.is_online ? 'online' : 'offline';
        const batteryText = App.formatBattery(device.battery_level);
        const batteryIcon = App.getBatteryIcon(device.battery_level);

        return `
            <div class="device-header">
                <div class="device-header-name">${device.name || 'Dispositivo sin nombre'}</div>
                <div class="device-header-info">
                    <div class="info-item">
                        <div class="info-label">Tipo</div>
                        <div class="info-value">${deviceType}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Estado</div>
                        <div class="info-value">
                            <span class="device-status ${statusClass}">
                                <span class="material-icons" style="font-size: 12px;">fiber_manual_record</span>
                                ${statusText}
                            </span>
                        </div>
                    </div>
                    ${device.serial_number ? `
                        <div class="info-item">
                            <div class="info-label">Serie</div>
                            <div class="info-value">${device.serial_number}</div>
                        </div>
                    ` : ''}
                    ${device.mac_address ? `
                        <div class="info-item">
                            <div class="info-label">MAC</div>
                            <div class="info-value">${device.mac_address}</div>
                        </div>
                    ` : ''}
                    ${device.battery_level !== null && device.battery_level !== undefined ? `
                        <div class="info-item">
                            <div class="info-label">Batería</div>
                            <div class="info-value">
                                <span class="material-icons" style="font-size: 16px; vertical-align: middle;">${batteryIcon}</span>
                                ${batteryText}
                            </div>
                        </div>
                    ` : ''}
                    ${device.signal_strength !== null && device.signal_strength !== undefined ? `
                        <div class="info-item">
                            <div class="info-label">Señal</div>
                            <div class="info-value">${device.signal_strength}%</div>
                        </div>
                    ` : ''}
                    ${device.location ? `
                        <div class="info-item">
                            <div class="info-label">Ubicación</div>
                            <div class="info-value">${device.location}</div>
                        </div>
                    ` : ''}
                    ${device.firmware_version ? `
                        <div class="info-item">
                            <div class="info-label">Firmware</div>
                            <div class="info-value">${device.firmware_version}</div>
                        </div>
                    ` : ''}
                </div>
            </div>
        `;
    },

    renderActions() {
        const isOnline = this.currentDevice?.is_online;
        
        return `
            <div class="actions-section">
                <h2 class="actions-title">Acciones Rápidas</h2>
                <div class="quick-actions" style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 24px;">
                    <button class="btn btn-primary" onclick="App.navigate('#/devices/${this.currentDevice?.id}/control')" ${!isOnline ? 'disabled' : ''}>
                        <span class="material-icons">touch_app</span>
                        Control
                    </button>
                    <button class="btn btn-secondary" onclick="App.navigate('#/devices/${this.currentDevice?.id}/edit')">
                        <span class="material-icons">edit</span>
                        Editar
                    </button>
                </div>
                
                <div class="device-management" style="display: grid; gap: 8px;">
                    <button class="action-btn" onclick="App.navigate('#/devices/${this.currentDevice?.id}/parameters')">
                        <div class="action-icon">
                            <span class="material-icons">settings</span>
                        </div>
                        <div class="action-details">
                            <div class="action-label">Parámetros</div>
                            <div class="action-description">Configurar comportamiento</div>
                        </div>
                        <span class="material-icons">chevron_right</span>
                    </button>
                    
                    <button class="action-btn" onclick="App.navigate('#/devices/${this.currentDevice?.id}/info')">
                        <div class="action-icon">
                            <span class="material-icons">info</span>
                        </div>
                        <div class="action-details">
                            <div class="action-label">Información</div>
                            <div class="action-description">Detalles técnicos</div>
                        </div>
                        <span class="material-icons">chevron_right</span>
                    </button>
                    
                    <button class="action-btn" onclick="App.navigate('#/devices/${this.currentDevice?.id}/users')">
                        <div class="action-icon">
                            <span class="material-icons">people</span>
                        </div>
                        <div class="action-details">
                            <div class="action-label">Usuarios</div>
                            <div class="action-description">Gestionar accesos</div>
                        </div>
                        <span class="material-icons">chevron_right</span>
                    </button>
                    
                    <button class="action-btn" onclick="App.navigate('#/devices/${this.currentDevice?.id}/events')">
                        <div class="action-icon">
                            <span class="material-icons">timeline</span>
                        </div>
                        <div class="action-details">
                            <div class="action-label">Eventos</div>
                            <div class="action-description">Historial de actividad</div>
                        </div>
                        <span class="material-icons">chevron_right</span>
                    </button>
                </div>
            </div>
        `;
    },

    renderActionButton(action) {
        // Translate common action labels to Spanish
        const labelTranslations = {
            'OPEN': 'Abrir',
            'CLOSE': 'Cerrar',
            'STOP': 'Detener',
            'START': 'Iniciar',
            'LOCK': 'Bloquear',
            'UNLOCK': 'Desbloquear',
            'TOGGLE': 'Alternar',
            'RESET': 'Reiniciar',
            'STATUS': 'Estado',
            'INFO': 'Información',
            'ON': 'Encender',
            'OFF': 'Apagar'
        };

        const command = action.mqtt_ac || action.command || action.name;
        const label = labelTranslations[command] || action.label || command;
        const icon = action.icon || this.getDefaultActionIcon(command);
        const isDisabled = !this.currentDevice?.is_online;

        return `
            <button 
                class="action-btn ${isDisabled ? 'disabled' : ''}" 
                data-command="${command}"
                onclick="DeviceDetailScreen.executeAction('${command}')"
                ${isDisabled ? 'disabled' : ''}
                title="${isDisabled ? 'Dispositivo desconectado' : label}"
            >
                <span class="action-icon material-icons">${icon}</span>
                <span class="action-label">${label}</span>
            </button>
        `;
    },

    getDefaultActionIcon(command) {
        const iconMap = {
            'OPEN': 'sensor_door',
            'CLOSE': 'door_front',
            'STOP': 'stop',
            'START': 'play_arrow',
            'LOCK': 'lock',
            'UNLOCK': 'lock_open',
            'TOGGLE': 'swap_horiz',
            'RESET': 'restart_alt',
            'STATUS': 'info',
            'INFO': 'info',
            'ON': 'power_settings_new',
            'OFF': 'power_off'
        };
        return iconMap[command] || 'touch_app';
    },

    renderError(errorMessage) {
        return `
            <div class="device-detail-container">
                <div class="header">
                    <button class="header-back material-icons" onclick="App.goBack()">
                        arrow_back
                    </button>
                    <h1 class="header-title">Error</h1>
                </div>
                <div class="device-detail">
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

    async executeAction(command) {
        if (!this.currentDevice || !command) {
            App.showToast('Error: comando no válido', 'error');
            return;
        }

        // Find the button that was clicked to show loading state
        const button = document.querySelector(`[data-command="${command}"]`);
        if (button) {
            button.classList.add('loading');
            button.disabled = true;
            const originalContent = button.innerHTML;
            button.innerHTML = `
                <div class="spinner" style="width: 20px; height: 20px; border-width: 2px;"></div>
                <span class="action-label">Enviando...</span>
            `;
        }

        try {
            const result = await API.sendCommand(this.currentDevice.id, command);

            if (result.success) {
                App.showToast(`Comando ${command} enviado`, 'success');
                App.showCommandResponse(result.data, 'success');
            } else {
                App.showToast(`Error: ${result.error}`, 'error');
                App.showCommandResponse(result.error, 'error');
            }
        } catch (error) {
            console.error('Error executing action:', error);
            App.showToast('Error de conexión', 'error');
            App.showCommandResponse('Error de conexión', 'error');
        } finally {
            // Restore button state
            if (button) {
                button.classList.remove('loading');
                button.disabled = false;
                
                const action = this.deviceActions.find(a => a.mqtt_ac === command || a.command === command);
                const label = action ? action.label || command : command;
                const icon = action ? action.icon || this.getDefaultActionIcon(command) : this.getDefaultActionIcon(command);
                
                button.innerHTML = `
                    <span class="action-icon material-icons">${icon}</span>
                    <span class="action-label">${label}</span>
                `;
            }
        }
    },

    // Initialize after render
    init() {
        // Add any additional initialization if needed
        console.log('Device detail screen initialized');
    }
};

// Auto-initialize when content is rendered
document.addEventListener('DOMContentLoaded', () => {
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.addedNodes) {
                mutation.addedNodes.forEach((node) => {
                    if (node.nodeType === Node.ELEMENT_NODE) {
                        const detailContainer = node.querySelector('.device-detail-container') || 
                                              (node.classList && node.classList.contains('device-detail-container') ? node : null);
                        if (detailContainer) {
                            setTimeout(() => DeviceDetailScreen.init(), 0);
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

window.DeviceDetailScreen = DeviceDetailScreen;