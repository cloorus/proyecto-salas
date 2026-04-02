// Device Info Screen Module
const DeviceInfoScreen = {
    currentDevice: null,

    async render(deviceId) {
        if (!deviceId) {
            return this.renderError('ID de dispositivo no proporcionado');
        }

        try {
            App.showLoading();

            const deviceResult = await API.getDeviceDetail(deviceId);

            App.hideLoading();

            if (!deviceResult.success) {
                return this.renderError(deviceResult.error || 'Error cargando dispositivo');
            }

            this.currentDevice = deviceResult.data;

            return `
                <div class="device-info-container">
                    ${this.renderHeader()}
                    ${this.renderDeviceInfoBanner()}
                    ${this.renderDeviceDetails()}
                    ${this.renderActions()}
                </div>
            `;
        } catch (error) {
            console.error('Error rendering device info:', error);
            App.hideLoading();
            return this.renderError('Error cargando información del dispositivo');
        }
    },

    renderHeader() {
        return `
            <div class="header">
                <button class="header-back material-icons" onclick="App.goBack()">
                    arrow_back
                </button>
                <h1 class="header-title" style="color: var(--title-blue); font-family: 'Montserrat', sans-serif;">Información del Dispositivo</h1>
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

    renderDeviceDetails() {
        const device = this.currentDevice;
        if (!device) return '';

        // Mock some additional data that might come from a more detailed API
        const mockDetails = {
            total_cycles: device.total_cycles || 1250,
            maintenance_cycles: device.maintenance_cycles || 5000,
            last_maintenance: device.last_maintenance || '2024-01-15',
            installation_date: device.installation_date || device.activation_date || '2023-06-10',
            warranty_expiration: device.warranty_expiration || '2025-06-10'
        };

        return `
            <div class="device-details-section" style="margin: 16px;">
                <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px; font-family: 'Montserrat', sans-serif;">
                    <span class="material-icons" style="vertical-align: middle; margin-right: 8px;">info</span>
                    Detalles Técnicos
                </h3>
                
                <div class="info-grid" style="display: grid; gap: 16px;">
                    ${this.renderInfoCard('Identificación', [
                        { label: 'Número de Serie', value: device.serial_number || 'N/A', icon: 'qr_code' },
                        { label: 'Dirección MAC', value: device.mac_address || 'N/A', icon: 'device_hub' },
                        { label: 'Modelo', value: device.model || 'N/A', icon: 'category' },
                        { label: 'Tipo', value: App.formatDeviceType(device.device_type) || 'N/A', icon: 'devices' }
                    ])}
                    
                    ${this.renderInfoCard('Versión y Firmware', [
                        { label: 'Versión de Firmware', value: device.firmware_version || 'N/A', icon: 'system_update' },
                        { label: 'Versión de Hardware', value: device.hardware_version || 'v1.2', icon: 'memory' },
                        { label: 'Bootloader', value: device.bootloader_version || 'v2.1', icon: 'developer_board' }
                    ])}
                    
                    ${this.renderInfoCard('Ciclos y Mantenimiento', [
                        { label: 'Ciclos Totales', value: mockDetails.total_cycles.toLocaleString(), icon: 'loop' },
                        { label: 'Próximo Mantenimiento', value: `${mockDetails.maintenance_cycles.toLocaleString()} ciclos`, icon: 'build' },
                        { label: 'Último Mantenimiento', value: this.formatDate(mockDetails.last_maintenance), icon: 'schedule' }
                    ])}
                    
                    ${this.renderInfoCard('Fechas Importantes', [
                        { label: 'Fecha de Activación', value: this.formatDate(device.activation_date), icon: 'event' },
                        { label: 'Fecha de Instalación', value: this.formatDate(mockDetails.installation_date), icon: 'construction' },
                        { label: 'Garantía Hasta', value: this.formatDate(mockDetails.warranty_expiration), icon: 'verified' }
                    ])}
                    
                    ${this.renderInfoCard('Estado de Conexión', [
                        { label: 'Estado', value: device.is_online ? 'En línea' : 'Desconectado', icon: 'wifi', status: device.is_online ? 'online' : 'offline' },
                        { label: 'Intensidad de Señal', value: device.signal_strength ? `${device.signal_strength}%` : 'N/A', icon: 'signal_cellular_alt' },
                        { label: 'Última Conexión', value: this.formatDateTime(device.last_seen), icon: 'access_time' },
                        { label: 'Nivel de Batería', value: device.battery_level !== null ? `${device.battery_level}%` : 'N/A', icon: App.getBatteryIcon(device.battery_level) || 'battery_unknown' }
                    ])}
                    
                    ${this.renderInfoCard('Ubicación y Configuración', [
                        { label: 'Ubicación', value: device.location || 'No configurada', icon: 'place' },
                        { label: 'Zona Horaria', value: device.timezone || 'America/Bogota', icon: 'schedule' },
                        { label: 'Grupo', value: device.group_name || 'Sin grupo', icon: 'group_work' },
                        { label: 'Contacto Técnico', value: device.technician_contact || 'No asignado', icon: 'support_agent' }
                    ])}
                </div>
            </div>
        `;
    },

    renderInfoCard(title, items) {
        return `
            <div class="info-card" style="background-color: var(--surface-color); border-radius: 8px; padding: 16px; border: 1px solid var(--divider-color);">
                <h4 style="color: var(--text-primary); font-weight: 600; margin-bottom: 12px; display: flex; align-items: center;">
                    ${title}
                </h4>
                <div class="info-items" style="display: grid; gap: 8px;">
                    ${items.map(item => `
                        <div class="info-item" style="display: flex; align-items: center; gap: 12px; padding: 8px 0;">
                            <span class="material-icons" style="color: var(--primary-purple); font-size: 20px;">${item.icon}</span>
                            <div style="flex: 1;">
                                <div style="font-size: 12px; color: var(--text-secondary);">${item.label}</div>
                                <div style="font-weight: 500; color: var(--text-primary); ${item.status ? `color: var(--${item.status === 'online' ? 'success' : 'error'}-color);` : ''}">${item.value}</div>
                            </div>
                        </div>
                    `).join('')}
                </div>
            </div>
        `;
    },

    renderActions() {
        return `
            <div class="device-actions" style="margin: 16px; margin-top: 32px;">
                <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px; font-family: 'Montserrat', sans-serif;">
                    <span class="material-icons" style="vertical-align: middle; margin-right: 8px;">settings</span>
                    Acciones
                </h3>
                
                <div class="actions-grid" style="display: grid; gap: 12px;">
                    <button class="action-card-btn" onclick="DeviceInfoScreen.updateDevice()" style="display: flex; align-items: center; gap: 16px; padding: 16px; background-color: var(--surface-color); border: 1px solid var(--divider-color); border-radius: 8px; cursor: pointer; transition: all 0.2s;">
                        <span class="material-icons" style="color: var(--secondary-blue); font-size: 24px;">system_update</span>
                        <div style="text-align: left; flex: 1;">
                            <div style="font-weight: 600; color: var(--text-primary);">Actualizar Dispositivo</div>
                            <div style="font-size: 14px; color: var(--text-secondary);">Verificar y descargar actualizaciones de firmware</div>
                        </div>
                        <span class="material-icons" style="color: var(--text-hint);">chevron_right</span>
                    </button>
                    
                    <button class="action-card-btn" onclick="DeviceInfoScreen.downloadReport()" style="display: flex; align-items: center; gap: 16px; padding: 16px; background-color: var(--surface-color); border: 1px solid var(--divider-color); border-radius: 8px; cursor: pointer; transition: all 0.2s;">
                        <span class="material-icons" style="color: var(--secondary-blue); font-size: 24px;">download</span>
                        <div style="text-align: left; flex: 1;">
                            <div style="font-weight: 600; color: var(--text-primary);">Descargar Reporte</div>
                            <div style="font-size: 14px; color: var(--text-secondary);">Generar reporte técnico completo</div>
                        </div>
                        <span class="material-icons" style="color: var(--text-hint);">chevron_right</span>
                    </button>
                    
                    <button class="action-card-btn" onclick="DeviceInfoScreen.factoryReset()" style="display: flex; align-items: center; gap: 16px; padding: 16px; background-color: var(--surface-color); border: 1px solid var(--error-color); border-radius: 8px; cursor: pointer; transition: all 0.2s;">
                        <span class="material-icons" style="color: var(--error-color); font-size: 24px;">settings_backup_restore</span>
                        <div style="text-align: left; flex: 1;">
                            <div style="font-weight: 600; color: var(--error-color);">Restaurar de Fábrica</div>
                            <div style="font-size: 14px; color: var(--text-secondary);">⚠️ Esta acción no se puede deshacer</div>
                        </div>
                        <span class="material-icons" style="color: var(--text-hint);">chevron_right</span>
                    </button>
                </div>
            </div>
        `;
    },

    renderError(errorMessage) {
        return `
            <div class="device-info-container">
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

    // Initialize device info screen events after render
    init() {
        // Add hover effects for action cards
        const actionCards = document.querySelectorAll('.action-card-btn');
        actionCards.forEach(card => {
            card.addEventListener('mouseenter', () => {
                card.style.backgroundColor = 'rgba(123, 44, 191, 0.04)';
                card.style.transform = 'translateY(-1px)';
            });
            
            card.addEventListener('mouseleave', () => {
                card.style.backgroundColor = 'var(--surface-color)';
                card.style.transform = 'translateY(0)';
            });
        });
    },

    // Action methods
    async updateDevice() {
        if (!this.currentDevice) return;
        
        try {
            App.showToast('Verificando actualizaciones...', 'info');
            
            // Mock update check
            await new Promise(resolve => setTimeout(resolve, 2000));
            
            App.showToast('El dispositivo tiene la versión más reciente', 'success');
            
        } catch (error) {
            console.error('Update check error:', error);
            App.showToast('Error verificando actualizaciones', 'error');
        }
    },

    async downloadReport() {
        if (!this.currentDevice) return;
        
        try {
            App.showToast('Generando reporte técnico...', 'info');
            
            // Mock report generation
            await new Promise(resolve => setTimeout(resolve, 1500));
            
            // In a real implementation, this would trigger a download
            App.showToast('Reporte generado exitosamente', 'success');
            
        } catch (error) {
            console.error('Report generation error:', error);
            App.showToast('Error generando reporte', 'error');
        }
    },

    factoryReset() {
        if (!this.currentDevice) return;
        
        // Show confirmation dialog
        if (confirm(`⚠️ ¿Estás seguro de que quieres restaurar "${this.currentDevice.name}" a configuración de fábrica?\n\nEsta acción eliminará todas las configuraciones personalizadas y no se puede deshacer.`)) {
            this.performFactoryReset();
        }
    },

    async performFactoryReset() {
        try {
            App.showToast('Restaurando dispositivo...', 'warning');
            
            // Mock factory reset
            await new Promise(resolve => setTimeout(resolve, 3000));
            
            App.showToast('Dispositivo restaurado exitosamente', 'success');
            App.navigate('#/devices');
            
        } catch (error) {
            console.error('Factory reset error:', error);
            App.showToast('Error restaurando dispositivo', 'error');
        }
    },

    // Utility methods
    formatDate(dateString) {
        if (!dateString) return 'N/A';
        try {
            const date = new Date(dateString);
            return date.toLocaleDateString('es-ES', {
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
        } catch {
            return dateString;
        }
    },

    formatDateTime(dateString) {
        if (!dateString) return 'N/A';
        try {
            const date = new Date(dateString);
            return date.toLocaleString('es-ES', {
                year: 'numeric',
                month: 'short',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        } catch {
            return dateString;
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
                        const infoContainer = node.querySelector('.device-info-container') || 
                                            (node.classList && node.classList.contains('device-info-container') ? node : null);
                        if (infoContainer) {
                            setTimeout(() => DeviceInfoScreen.init(), 0);
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

window.DeviceInfoScreen = DeviceInfoScreen;