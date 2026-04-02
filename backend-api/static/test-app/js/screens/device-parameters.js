// Device Parameters Screen Module
const DeviceParametersScreen = {
    currentDevice: null,
    parameters: null,

    async render(deviceId) {
        if (!deviceId) {
            return this.renderError('ID de dispositivo no proporcionado');
        }

        try {
            App.showLoading();

            // Fetch device details and parameters
            const [deviceResult, paramsResult] = await Promise.all([
                API.getDeviceDetail(deviceId),
                API.getDeviceParams(deviceId)
            ]);

            App.hideLoading();

            if (!deviceResult.success) {
                return this.renderError(deviceResult.error || 'Error cargando dispositivo');
            }

            // Handle /full endpoint response format: {device: {...}, parameters: {...}, ...}
            if (deviceResult.data && deviceResult.data.device) {
                this.currentDevice = deviceResult.data.device;
                // If parameters are included in the full response, use them as fallback
                if (!paramsResult.success && deviceResult.data.parameters) {
                    this.parameters = deviceResult.data.parameters;
                    return `
                        <div class="device-parameters-container">
                            ${this.renderHeader()}
                            ${this.renderDeviceInfoBanner()}
                            ${this.renderParametersForm()}
                        </div>
                    `;
                }
            } else {
                this.currentDevice = deviceResult.data;
            }
            
            // Handle case where params endpoint returns 501/503 (service not available)
            if (!paramsResult.success && (paramsResult.error?.includes('501') || paramsResult.error?.includes('503') || paramsResult.error?.includes('Device not responding'))) {
                this.parameters = this.getMockParameters();
                App.showToast('Servicio no disponible - usando datos de demostración', 'warning');
            } else if (paramsResult.success) {
                this.parameters = paramsResult.data;
            } else {
                this.parameters = this.getMockParameters();
                App.showToast('Error obteniendo parámetros - usando datos de demostración', 'warning');
            }

            return `
                <div class="device-parameters-container">
                    ${this.renderHeader()}
                    ${this.renderDeviceInfoBanner()}
                    ${this.renderParametersForm()}
                </div>
            `;
        } catch (error) {
            console.error('Error rendering device parameters:', error);
            App.hideLoading();
            return this.renderError('Error cargando parámetros del dispositivo');
        }
    },

    renderHeader() {
        return `
            <div class="header">
                <button class="header-back material-icons" onclick="App.goBack()">
                    arrow_back
                </button>
                <h1 class="header-title" style="color: var(--title-blue); font-family: 'Montserrat', sans-serif;">Parámetros</h1>
            </div>
        `;
    },

    renderDeviceInfoBanner() {
        const device = this.currentDevice;
        if (!device) return '';

        return `
            <div class="device-info-banner" style="margin: 16px;">
                <div class="banner-title">${device.name || 'Dispositivo sin nombre'}</div>
                <div class="banner-details">
                    <div class="banner-detail">
                        <span class="banner-label">Modelo:</span>
                        <span class="banner-value">${device.model || 'N/A'}</span>
                    </div>
                    <div class="banner-detail">
                        <span class="banner-label">Serial:</span>
                        <span class="banner-value">${device.serial_number || 'N/A'}</span>
                    </div>
                    <div class="banner-detail">
                        <span class="banner-label">Estado:</span>
                        <span class="banner-value ${device.is_online ? 'online' : 'offline'}">
                            ${device.is_online ? 'En línea' : 'Desconectado'}
                        </span>
                    </div>
                    <div class="banner-detail">
                        <span class="banner-label">Detalle:</span>
                        <span class="banner-value">${device.firmware_version || 'N/A'}</span>
                    </div>
                </div>
            </div>
        `;
    },

    renderParametersForm() {
        if (!this.parameters) return '';

        return `
            <div class="form-container">
                <form class="parameters-form" id="parametersForm">
                    <div class="parameters-list">
                        ${this.renderParameterToggle('device_locked', 'Bloquear Dispositivo', 'Impide que el dispositivo responda a comandos', 'lock')}
                        ${this.renderParameterToggle('connection_reminder', 'Recordatorio de Conexión', 'Notifica cuando el dispositivo se desconecta', 'wifi_off')}
                        ${this.renderParameterToggle('door_reminder', 'Recordatorio de Puerta', 'Notifica si la puerta queda abierta por mucho tiempo', 'door_open')}
                        ${this.renderParameterToggle('forced_opening_alarm', 'Alarma de Apertura Forzada', 'Detecta y notifica aperturas no autorizadas', 'security')}
                        ${this.renderParameterToggle('keep_open', 'Mantener Abierto', 'El dispositivo permanece abierto hasta nueva orden', 'lock_open')}
                    </div>
                    
                    <div class="form-actions" style="margin-top: 32px; display: flex; gap: 12px;">
                        <button type="button" class="btn btn-secondary" id="refreshParamsButton" onclick="DeviceParametersScreen.refreshParameters()" style="flex: 1;">
                            <span class="material-icons">refresh</span>
                            Actualizar
                        </button>
                        <button type="submit" class="btn btn-primary" id="saveParamsButton" style="flex: 2;">
                            <span class="material-icons">save</span>
                            Guardar Parámetros
                        </button>
                    </div>
                    
                    <div id="parameters-error" class="form-error hidden mt-16"></div>
                </form>
            </div>
        `;
    },

    renderParameterToggle(paramKey, title, description, icon) {
        const isChecked = this.parameters[paramKey] || false;
        
        return `
            <div class="parameter-item" style="padding: 16px; border-bottom: 1px solid var(--divider-color);">
                <div style="display: flex; align-items: center; gap: 16px;">
                    <span class="material-icons" style="color: var(--primary-purple); font-size: 24px;">${icon}</span>
                    <div style="flex: 1;">
                        <div class="parameter-title" style="font-weight: 600; margin-bottom: 4px; color: var(--text-primary);">${title}</div>
                        <div class="parameter-description" style="font-size: 14px; color: var(--text-secondary);">${description}</div>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" id="${paramKey}" ${isChecked ? 'checked' : ''}>
                        <span class="toggle-slider"></span>
                    </label>
                </div>
            </div>
        `;
    },

    renderError(errorMessage) {
        return `
            <div class="device-parameters-container">
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

    getMockParameters() {
        return {
            device_locked: false,
            connection_reminder: true,
            door_reminder: true,
            forced_opening_alarm: false,
            keep_open: false
        };
    },

    // Initialize device parameters screen events after render
    init() {
        const form = document.getElementById('parametersForm');
        if (!form) return;

        // Handle form submission
        form.addEventListener('submit', async (e) => {
            e.preventDefault();
            await this.handleSaveParameters();
        });

        // Handle toggle changes (for immediate feedback)
        const toggles = form.querySelectorAll('input[type="checkbox"]');
        toggles.forEach(toggle => {
            toggle.addEventListener('change', (e) => {
                this.handleToggleChange(e.target.id, e.target.checked);
            });
        });
    },

    async handleSaveParameters() {
        const formData = this.getFormData();
        const button = document.getElementById('saveParamsButton');

        // Clear previous errors
        this.clearAllErrors();

        // Show loading state
        this.setLoadingState(button, true);

        try {
            // Try to call real API first
            const result = await API.updateDeviceParams(this.currentDevice.id, formData);
            
            if (result.success) {
                App.showToast('Parámetros actualizados exitosamente', 'success');
                this.parameters = { ...this.parameters, ...formData };
            } else if (result.error?.includes('501')) {
                // Mock success for 501 responses
                App.showToast('Parámetros actualizados (modo demo)', 'success');
                this.parameters = { ...this.parameters, ...formData };
            } else {
                throw new Error(result.error || 'Error actualizando parámetros');
            }
            
        } catch (error) {
            console.error('Save parameters error:', error);
            this.showError('parameters-error', 'Error guardando parámetros. Intenta nuevamente.');
        } finally {
            this.setLoadingState(button, false);
        }
    },

    async refreshParameters() {
        const button = document.getElementById('refreshParamsButton');
        this.setLoadingState(button, true, 'Actualizando...');

        try {
            const result = await API.refreshDeviceParams(this.currentDevice.id);
            
            if (result.success) {
                // Refresh the page with new parameters
                const newResult = await API.getDeviceParams(this.currentDevice.id);
                if (newResult.success) {
                    this.parameters = newResult.data;
                    // Update toggles with new values
                    this.updateTogglesFromParameters();
                    App.showToast('Parámetros actualizados desde el dispositivo', 'success');
                }
            } else if (result.error?.includes('501')) {
                App.showToast('Actualización no disponible (modo demo)', 'warning');
            } else {
                throw new Error(result.error || 'Error actualizando parámetros');
            }
            
        } catch (error) {
            console.error('Refresh parameters error:', error);
            App.showToast('Error actualizando parámetros', 'error');
        } finally {
            this.setLoadingState(button, false, 'Actualizar');
        }
    },

    handleToggleChange(paramKey, value) {
        // Provide immediate visual feedback
        const toggleItem = document.getElementById(paramKey).closest('.parameter-item');
        if (toggleItem) {
            toggleItem.style.backgroundColor = value ? 'rgba(123, 44, 191, 0.05)' : '';
            setTimeout(() => {
                toggleItem.style.backgroundColor = '';
            }, 500);
        }
    },

    getFormData() {
        return {
            device_locked: document.getElementById('device_locked').checked,
            connection_reminder: document.getElementById('connection_reminder').checked,
            door_reminder: document.getElementById('door_reminder').checked,
            forced_opening_alarm: document.getElementById('forced_opening_alarm').checked,
            keep_open: document.getElementById('keep_open').checked
        };
    },

    updateTogglesFromParameters() {
        Object.keys(this.parameters).forEach(key => {
            const toggle = document.getElementById(key);
            if (toggle) {
                toggle.checked = this.parameters[key];
            }
        });
    },

    showError(elementId, message) {
        const errorElement = document.getElementById(elementId);
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.classList.remove('hidden');
        }
    },

    clearError(elementId) {
        const errorElement = document.getElementById(elementId);
        if (errorElement) {
            errorElement.textContent = '';
            errorElement.classList.add('hidden');
        }
    },

    clearAllErrors() {
        const errorElements = document.querySelectorAll('.form-error');
        errorElements.forEach(el => {
            el.textContent = '';
            el.classList.add('hidden');
        });
    },

    setLoadingState(button, loading, text = 'Cargando...') {
        if (!button) return;

        if (loading) {
            button.disabled = true;
            button.innerHTML = `
                <div class="spinner" style="width: 16px; height: 16px; border-width: 2px;"></div>
                ${text}
            `;
        } else {
            button.disabled = false;
            // Restore original button content based on button ID
            if (button.id === 'saveParamsButton') {
                button.innerHTML = `
                    <span class="material-icons">save</span>
                    Guardar Parámetros
                `;
            } else if (button.id === 'refreshParamsButton') {
                button.innerHTML = `
                    <span class="material-icons">refresh</span>
                    Actualizar
                `;
            }
        }
    }
};

// Auto-initialize when content is rendered
document.addEventListener('DOMContentLoaded', () => {
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.addedNodes) {
                mutation.addedNodes.forEach((node) => {
                    if (node.nodeType === Node.ELEMENT_NODE) {
                        const paramsContainer = node.querySelector('.device-parameters-container') || 
                                              (node.classList && node.classList.contains('device-parameters-container') ? node : null);
                        if (paramsContainer) {
                            setTimeout(() => DeviceParametersScreen.init(), 0);
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

window.DeviceParametersScreen = DeviceParametersScreen;