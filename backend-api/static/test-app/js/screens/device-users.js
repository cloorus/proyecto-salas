// Device Users Screen Module  
const DeviceUsersScreen = {
    currentDevice: null,
    authorizedUsers: [],
    availableUsers: [],

    async render(deviceId) {
        if (!deviceId) {
            return this.renderError('ID de dispositivo no proporcionado');
        }

        try {
            App.showLoading();

            // Fetch device details and users
            const [deviceResult, usersResult] = await Promise.all([
                API.getDeviceDetail(deviceId),
                API.getDeviceUsers(deviceId)
            ]);

            App.hideLoading();

            if (!deviceResult.success) {
                return this.renderError(deviceResult.error || 'Error cargando dispositivo');
            }

            // Handle /full endpoint response format
            if (deviceResult.data && deviceResult.data.device) {
                this.currentDevice = deviceResult.data.device;
                // If users are included in the full response, use them
                if (!usersResult.success && deviceResult.data.users) {
                    this.authorizedUsers = deviceResult.data.users || [];
                    this.availableUsers = this.getMockAvailableUsers();
                    return `
                        <div class="device-users-container">
                            ${this.renderHeader()}
                            ${this.renderDeviceInfoBanner()}
                            ${this.renderAuthorizedUsers()}
                            ${this.renderAvailableUsers()}
                            ${this.renderActions()}
                        </div>
                    `;
                }
            } else {
                this.currentDevice = deviceResult.data;
            }
            
            // Handle case where users endpoint returns 501
            if (!usersResult.success && usersResult.error?.includes('501')) {
                this.authorizedUsers = this.getMockAuthorizedUsers();
                this.availableUsers = this.getMockAvailableUsers();
                App.showToast('Usando datos de demostración (API no disponible)', 'warning');
            } else if (usersResult.success) {
                this.authorizedUsers = usersResult.data?.authorized || [];
                this.availableUsers = usersResult.data?.available || [];
            } else {
                this.authorizedUsers = this.getMockAuthorizedUsers();
                this.availableUsers = this.getMockAvailableUsers();
            }

            return `
                <div class="device-users-container">
                    ${this.renderHeader()}
                    ${this.renderDeviceInfoBanner()}
                    ${this.renderAuthorizedUsers()}
                    ${this.renderAvailableUsers()}
                    ${this.renderActions()}
                </div>
            `;
        } catch (error) {
            console.error('Error rendering device users:', error);
            App.hideLoading();
            return this.renderError('Error cargando usuarios del dispositivo');
        }
    },

    renderHeader() {
        return `
            <div class="header">
                <button class="header-back material-icons" onclick="App.goBack()">
                    arrow_back
                </button>
                <h1 class="header-title" style="color: var(--title-blue); font-family: 'Montserrat', sans-serif;">Usuarios con Acceso</h1>
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

    renderAuthorizedUsers() {
        return `
            <div class="users-section" style="margin: 16px;">
                <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px; font-family: 'Montserrat', sans-serif;">
                    <span class="material-icons" style="vertical-align: middle; margin-right: 8px;">verified_user</span>
                    Usuarios Autorizados
                </h3>
                
                <div class="authorized-users-list">
                    ${this.authorizedUsers.length > 0 ? 
                        this.authorizedUsers.map(user => this.renderAuthorizedUser(user)).join('') :
                        '<div class="empty-state" style="text-align: center; padding: 32px; color: var(--text-secondary);">No hay usuarios autorizados</div>'
                    }
                </div>
            </div>
        `;
    },

    renderAuthorizedUser(user) {
        const accessTypeIcon = this.getAccessTypeIcon(user.access_type);
        const accessTypeLabel = this.getAccessTypeLabel(user.access_type);
        const statusColor = user.is_active ? 'var(--success-color)' : 'var(--text-hint)';

        return `
            <div class="user-card" style="display: flex; align-items: center; gap: 16px; padding: 16px; background-color: var(--surface-color); border-radius: 8px; margin-bottom: 12px; border: 1px solid var(--divider-color);">
                <div class="user-avatar" style="width: 48px; height: 48px; border-radius: 50%; background: linear-gradient(135deg, var(--primary-purple), var(--accent-purple)); display: flex; align-items: center; justify-content: center; color: white; font-weight: 600;">
                    ${user.name ? user.name.charAt(0).toUpperCase() : 'U'}
                </div>
                
                <div class="user-info" style="flex: 1;">
                    <div class="user-name" style="font-weight: 600; color: var(--text-primary); margin-bottom: 4px;">${user.name || 'Usuario sin nombre'}</div>
                    <div class="user-email" style="color: var(--text-secondary); font-size: 14px; margin-bottom: 4px;">${user.email || 'Sin email'}</div>
                    <div class="user-access-info" style="display: flex; align-items: center; gap: 12px;">
                        <div style="display: flex; align-items: center; gap: 4px; color: var(--primary-purple);">
                            <span class="material-icons" style="font-size: 16px;">${accessTypeIcon}</span>
                            <span style="font-size: 12px; font-weight: 500;">${accessTypeLabel}</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 4px; color: ${statusColor};">
                            <span class="material-icons" style="font-size: 12px;">fiber_manual_record</span>
                            <span style="font-size: 12px;">${user.is_active ? 'Activo' : 'Inactivo'}</span>
                        </div>
                    </div>
                </div>
                
                <div class="user-actions">
                    <button class="btn btn-secondary" onclick="DeviceUsersScreen.editUserPermissions('${user.id}')" style="padding: 8px 16px; font-size: 12px;">
                        <span class="material-icons" style="font-size: 16px;">edit</span>
                        Editar
                    </button>
                </div>
            </div>
        `;
    },

    renderAvailableUsers() {
        if (this.availableUsers.length === 0) return '';

        return `
            <div class="users-section" style="margin: 16px;">
                <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px; font-family: 'Montserrat', sans-serif;">
                    <span class="material-icons" style="vertical-align: middle; margin-right: 8px;">group_add</span>
                    Usuarios Disponibles
                </h3>
                
                <div class="available-users-list">
                    ${this.availableUsers.map(user => this.renderAvailableUser(user)).join('')}
                </div>
            </div>
        `;
    },

    renderAvailableUser(user) {
        return `
            <div class="user-card" style="display: flex; align-items: center; gap: 16px; padding: 16px; background-color: var(--surface-color); border-radius: 8px; margin-bottom: 12px; border: 1px solid var(--divider-color);">
                <div class="user-avatar" style="width: 48px; height: 48px; border-radius: 50%; background-color: var(--text-hint); display: flex; align-items: center; justify-content: center; color: white; font-weight: 600;">
                    ${user.name ? user.name.charAt(0).toUpperCase() : 'U'}
                </div>
                
                <div class="user-info" style="flex: 1;">
                    <div class="user-name" style="font-weight: 600; color: var(--text-primary); margin-bottom: 4px;">${user.name || 'Usuario sin nombre'}</div>
                    <div class="user-email" style="color: var(--text-secondary); font-size: 14px;">${user.email || 'Sin email'}</div>
                </div>
                
                <div class="user-actions">
                    <button class="btn" onclick="DeviceUsersScreen.addUserToDevice('${user.id}')" style="background-color: var(--success-color); color: white; padding: 8px 16px; font-size: 12px;">
                        <span class="material-icons" style="font-size: 16px;">check</span>
                        Agregar
                    </button>
                </div>
            </div>
        `;
    },

    renderActions() {
        return `
            <div class="users-actions" style="margin: 16px; margin-top: 32px;">
                <div class="actions-grid" style="display: grid; gap: 12px;">
                    <button class="action-card-btn btn btn-secondary" onclick="DeviceUsersScreen.linkExistingUser()" style="display: flex; align-items: center; justify-content: center; gap: 12px; padding: 16px;">
                        <span class="material-icons">person_add</span>
                        <span>Vincular Usuario Existente</span>
                    </button>
                    
                    <button class="action-card-btn btn btn-primary" onclick="DeviceUsersScreen.createVirtualUser()" style="display: flex; align-items: center; justify-content: center; gap: 12px; padding: 16px;">
                        <span class="material-icons">add_circle</span>
                        <span>Crear Usuario Virtual</span>
                    </button>
                    
                    <button class="action-card-btn btn btn-secondary" onclick="DeviceUsersScreen.managePermissions()" style="display: flex; align-items: center; justify-content: center; gap: 12px; padding: 16px;">
                        <span class="material-icons">admin_panel_settings</span>
                        <span>Gestionar Permisos</span>
                    </button>
                </div>
            </div>
        `;
    },

    renderError(errorMessage) {
        return `
            <div class="device-users-container">
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

    // Mock data generators
    getMockAuthorizedUsers() {
        return [
            {
                id: '1',
                name: 'Juan Pérez',
                email: 'juan.perez@example.com',
                access_type: 'app',
                is_active: true,
                granted_date: '2024-01-15'
            },
            {
                id: '2', 
                name: 'María García',
                email: 'maria.garcia@example.com',
                access_type: 'bluetooth',
                is_active: true,
                granted_date: '2024-02-01'
            },
            {
                id: '3',
                name: 'Control Remoto #1',
                email: '',
                access_type: 'remote',
                is_active: false,
                granted_date: '2024-01-10'
            }
        ];
    },

    getMockAvailableUsers() {
        return [
            {
                id: '4',
                name: 'Carlos López',
                email: 'carlos.lopez@example.com'
            },
            {
                id: '5',
                name: 'Ana Martínez',
                email: 'ana.martinez@example.com'
            }
        ];
    },

    // Utility methods
    getAccessTypeIcon(accessType) {
        const icons = {
            'app': 'smartphone',
            'bluetooth': 'bluetooth',
            'remote': 'settings_remote'
        };
        return icons[accessType] || 'person';
    },

    getAccessTypeLabel(accessType) {
        const labels = {
            'app': 'App',
            'bluetooth': 'Bluetooth',
            'remote': 'Control Remoto'
        };
        return labels[accessType] || 'Desconocido';
    },

    // Initialize device users screen events after render
    init() {
        // Add hover effects for user cards
        const userCards = document.querySelectorAll('.user-card');
        userCards.forEach(card => {
            card.addEventListener('mouseenter', () => {
                card.style.backgroundColor = 'rgba(123, 44, 191, 0.04)';
                card.style.transform = 'translateY(-1px)';
                card.style.boxShadow = '0 4px 12px rgba(0,0,0,0.1)';
            });
            
            card.addEventListener('mouseleave', () => {
                card.style.backgroundColor = 'var(--surface-color)';
                card.style.transform = 'translateY(0)';
                card.style.boxShadow = 'none';
            });
        });
    },

    // Action methods
    editUserPermissions(userId) {
        App.navigate(`#/devices/${this.currentDevice.id}/users/${userId}/permissions`);
    },

    async addUserToDevice(userId) {
        try {
            App.showToast('Agregando usuario...', 'info');
            
            // Mock API call
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            // Move user from available to authorized
            const user = this.availableUsers.find(u => u.id === userId);
            if (user) {
                this.availableUsers = this.availableUsers.filter(u => u.id !== userId);
                this.authorizedUsers.push({
                    ...user,
                    access_type: 'app',
                    is_active: true,
                    granted_date: new Date().toISOString().split('T')[0]
                });
                
                // Re-render sections
                this.updateUserSections();
                App.showToast('Usuario agregado exitosamente', 'success');
            }
            
        } catch (error) {
            console.error('Add user error:', error);
            App.showToast('Error agregando usuario', 'error');
        }
    },

    linkExistingUser() {
        App.navigate(`#/devices/${this.currentDevice.id}/link-user`);
    },

    createVirtualUser() {
        App.navigate(`#/devices/${this.currentDevice.id}/virtual-user`);
    },

    managePermissions() {
        App.navigate(`#/devices/${this.currentDevice.id}/permissions`);
    },

    updateUserSections() {
        const authorizedContainer = document.querySelector('.authorized-users-list');
        const availableContainer = document.querySelector('.available-users-list');
        
        if (authorizedContainer) {
            authorizedContainer.innerHTML = this.authorizedUsers.length > 0 ? 
                this.authorizedUsers.map(user => this.renderAuthorizedUser(user)).join('') :
                '<div class="empty-state" style="text-align: center; padding: 32px; color: var(--text-secondary);">No hay usuarios autorizados</div>';
        }
        
        if (availableContainer) {
            availableContainer.innerHTML = this.availableUsers.map(user => this.renderAvailableUser(user)).join('');
        }
        
        // Re-init hover effects
        this.init();
    }
};

// Auto-initialize when content is rendered
document.addEventListener('DOMContentLoaded', () => {
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.addedNodes) {
                mutation.addedNodes.forEach((node) => {
                    if (node.nodeType === Node.ELEMENT_NODE) {
                        const usersContainer = node.querySelector('.device-users-container') || 
                                             (node.classList && node.classList.contains('device-users-container') ? node : null);
                        if (usersContainer) {
                            setTimeout(() => DeviceUsersScreen.init(), 0);
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

window.DeviceUsersScreen = DeviceUsersScreen;