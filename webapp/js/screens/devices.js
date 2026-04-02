// Devices List Screen Module
const DevicesScreen = {
    devices: [],

    async render() {
        try {
            // Fetch devices from API
            const result = await API.getDevices();
            
            if (!result.success) {
                return this.renderError(result.error);
            }

            // Handle response format: {data: [...], pagination: {...}}
            this.devices = Array.isArray(result.data) ? result.data : (result.data?.data || []);
            
            return `
                <div class="device-list-container">
                    ${this.renderHeader()}
                    ${this.renderDeviceList()}
                    ${this.renderBottomNavigation()}
                </div>
            `;
        } catch (error) {
            console.error('Error rendering devices screen:', error);
            return this.renderError('Error cargando dispositivos');
        }
    },

    renderHeader() {
        return `
            <div class="header">
                <button class="header-back material-icons" onclick="DevicesScreen.openDrawer()" title="Menú">
                    menu
                </button>
                <h1 class="header-title" style="color: var(--title-blue); font-family: 'Montserrat', sans-serif;">Dispositivos</h1>
                <button class="header-back material-icons" onclick="DevicesScreen.addDevice()" title="Agregar dispositivo">
                    add
                </button>
            </div>
        `;
    },

    renderBottomNavigation() {
        return `
            <div class="bottom-nav">
                <a href="#/devices" class="nav-item active">
                    <span class="material-icons">devices</span>
                    <span class="nav-label">Dispositivos</span>
                </a>
                <a href="#/settings" class="nav-item">
                    <span class="material-icons">settings</span>
                    <span class="nav-label">Configuración</span>
                </a>
                <a href="#/support" class="nav-item">
                    <span class="material-icons">support_agent</span>
                    <span class="nav-label">Soporte</span>
                </a>
            </div>
        `;
    },

    openDrawer() {
        // Create drawer if it doesn't exist
        let drawer = document.getElementById('mainDrawer');
        if (!drawer) {
            drawer = this.createDrawer();
            document.body.appendChild(drawer);
        }
        
        // Show drawer
        drawer.classList.add('active');
        drawer.querySelector('.drawer').classList.add('active');
    },

    createDrawer() {
        const drawerHTML = `
            <div class="drawer-overlay" id="mainDrawer" onclick="DevicesScreen.closeDrawer()">
                <div class="drawer" onclick="event.stopPropagation()">
                    <div class="drawer-header">
                        <div class="drawer-avatar">
                            <span class="material-icons">person</span>
                        </div>
                        <div>
                            <div style="font-weight: 700; margin-bottom: 4px;">Administrator</div>
                            <div class="drawer-email">admin@bgnius.com</div>
                        </div>
                    </div>
                    
                    <div class="drawer-menu">
                        <a href="#/devices" class="drawer-item">
                            <span class="material-icons">devices</span>
                            <span>Mis Dispositivos</span>
                        </a>
                        <a href="#/groups" class="drawer-item">
                            <span class="material-icons">group_work</span>
                            <span>Grupos</span>
                        </a>
                        <a href="#/events" class="drawer-item">
                            <span class="material-icons">timeline</span>
                            <span>Eventos</span>
                        </a>
                        <a href="#/settings" class="drawer-item">
                            <span class="material-icons">settings</span>
                            <span>Configuración</span>
                        </a>
                        <a href="#/support" class="drawer-item">
                            <span class="material-icons">support_agent</span>
                            <span>Soporte</span>
                        </a>
                        <div class="drawer-item" onclick="App.logout()">
                            <span class="material-icons">logout</span>
                            <span>Cerrar Sesión</span>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        const temp = document.createElement('div');
        temp.innerHTML = drawerHTML;
        return temp.firstElementChild;
    },

    closeDrawer() {
        const drawer = document.getElementById('mainDrawer');
        if (drawer) {
            drawer.classList.remove('active');
            drawer.querySelector('.drawer').classList.remove('active');
            
            // Remove after animation
            setTimeout(() => {
                if (drawer.parentNode) {
                    drawer.parentNode.removeChild(drawer);
                }
            }, 300);
        }
    },

    addDevice() {
        App.navigate('#/add-device');
    },

    renderDeviceList() {
        if (this.devices.length === 0) {
            return `
                <div class="device-list">
                    <div class="text-center" style="padding: 48px 24px;">
                        <span class="material-icons" style="font-size: 64px; color: var(--text-hint); margin-bottom: 16px;">devices</span>
                        <h3 style="color: var(--text-secondary); margin-bottom: 8px;">Sin dispositivos</h3>
                        <p style="color: var(--text-hint);">No se encontraron dispositivos en tu cuenta</p>
                    </div>
                </div>
            `;
        }

        const devicesHtml = this.devices.map(device => this.renderDeviceCard(device)).join('');
        
        return `
            <div class="device-list">
                ${devicesHtml}
            </div>
        `;
    },

    renderDeviceCard(device) {
        const deviceType = App.formatDeviceType(device.type || 'device');
        const deviceStatus = device.is_online ? 'online' : 'offline';
        const statusText = App.formatDeviceStatus(device.is_online);
        const deviceIcon = App.getDeviceIcon(device.type);
        const batteryLevel = device.battery_level;
        const batteryIcon = App.getBatteryIcon(batteryLevel);
        const batteryText = App.formatBattery(batteryLevel);

        return `
            <div class="device-card" data-device-id="${device.id}" onclick="DevicesScreen.navigateToDevice('${device.id}')">
                <div class="device-icon">
                    <span class="material-icons">${deviceIcon}</span>
                </div>
                <div class="device-info">
                    <div class="device-name">${device.name || 'Dispositivo sin nombre'}</div>
                    <div class="device-details">
                        <span class="device-type">${deviceType}</span>
                        <span class="device-status ${deviceStatus}">
                            <span class="material-icons" style="font-size: 12px;">fiber_manual_record</span>
                            ${statusText}
                        </span>
                        ${batteryLevel !== null && batteryLevel !== undefined ? `
                            <span class="device-battery">
                                <span class="material-icons" style="font-size: 14px;">${batteryIcon}</span>
                                ${batteryText}
                            </span>
                        ` : ''}
                    </div>
                </div>
                <div class="device-arrow">
                    <span class="material-icons" style="color: var(--text-hint);">chevron_right</span>
                </div>
            </div>
        `;
    },

    renderError(errorMessage) {
        return `
            <div class="device-list-container">
                ${this.renderHeader()}
                <div class="device-list">
                    <div class="text-center" style="padding: 48px 24px;">
                        <span class="material-icons" style="font-size: 64px; color: var(--error-color); margin-bottom: 16px;">error</span>
                        <h3 style="color: var(--error-color); margin-bottom: 8px;">Error</h3>
                        <p style="color: var(--text-secondary); margin-bottom: 24px;">${errorMessage}</p>
                        <button class="btn btn-primary" onclick="App.handleRoute()">
                            <span class="material-icons">refresh</span>
                            Reintentar
                        </button>
                    </div>
                </div>
            </div>
        `;
    },

    navigateToDevice(deviceId) {
        App.navigate(`#/devices/${deviceId}`);
    },

    // Initialize after render
    init() {
        // Add pull-to-refresh functionality (simple version)
        let startY = 0;
        let currentY = 0;
        let isRefreshing = false;

        const deviceList = document.querySelector('.device-list');
        if (!deviceList) return;

        deviceList.addEventListener('touchstart', (e) => {
            startY = e.touches[0].clientY;
        });

        deviceList.addEventListener('touchmove', (e) => {
            if (isRefreshing) return;
            
            currentY = e.touches[0].clientY;
            const diff = currentY - startY;
            
            // If scrolled to top and pulling down
            if (deviceList.scrollTop === 0 && diff > 50) {
                e.preventDefault();
                // Could add visual feedback here
            }
        });

        deviceList.addEventListener('touchend', (e) => {
            if (isRefreshing) return;
            
            const diff = currentY - startY;
            
            // If pulled down significantly while at top
            if (deviceList.scrollTop === 0 && diff > 100) {
                this.refreshDevices();
            }
            
            startY = 0;
            currentY = 0;
        });
    },

    async refreshDevices() {
        try {
            App.showToast('Actualizando dispositivos...', 'info');
            
            const result = await API.getDevices();
            
            if (result.success) {
                // Handle response format: {data: [...], pagination: {...}}
                this.devices = Array.isArray(result.data) ? result.data : (result.data?.data || []);
                // Re-render the device list
                const container = document.querySelector('.device-list');
                if (container) {
                    container.innerHTML = this.renderDeviceList().replace('<div class="device-list">', '').replace('</div>', '');
                }
                App.showToast('Dispositivos actualizados', 'success');
            } else {
                App.showToast('Error actualizando dispositivos', 'error');
            }
        } catch (error) {
            console.error('Error refreshing devices:', error);
            App.showToast('Error de conexión', 'error');
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
                        const deviceContainer = node.querySelector('.device-list-container') || 
                                              (node.classList && node.classList.contains('device-list-container') ? node : null);
                        if (deviceContainer) {
                            setTimeout(() => DevicesScreen.init(), 0);
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

window.DevicesScreen = DevicesScreen;