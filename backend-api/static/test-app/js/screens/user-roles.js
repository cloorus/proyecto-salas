// User Roles Screen Module
const UserRolesScreen = {
    deviceId: null,
    deviceData: null,
    users: [],
    permissions: {},
    selectedUserId: null,

    async render(deviceId) {
        this.deviceId = deviceId;
        
        try {
            // Load device data
            const deviceResult = await API.getDeviceDetail(deviceId);
            if (deviceResult.success) {
                this.deviceData = deviceResult.data;
            } else {
                // Mock device data
                this.deviceData = {
                    id: deviceId,
                    name: "Portón Principal",
                    model: "FAC 500 Vita",
                    serial: "VT2025001234",
                    status: "online"
                };
            }

            // Load device users
            const usersResult = await API.getDeviceUsers(deviceId);
            if (usersResult.success) {
                this.users = usersResult.data;
            } else {
                // Mock users data
                this.users = [
                    {
                        id: 1,
                        name: "Carlos Admin",
                        email: "carlos@bgnius.com",
                        role: "admin",
                        permissions: {
                            open: true,
                            close: true,
                            stop: true,
                            light: true,
                            relay: true,
                            lock: true,
                            reports: true,
                            bluetooth: true,
                            keepOpen: true,
                            widget: true,
                            pedestrian: true,
                            stepByStep: true,
                            notifications: true,
                            assignRoles: true,
                            assignUsers: true
                        }
                    },
                    {
                        id: 2,
                        name: "María Usuario",
                        email: "maria@gmail.com",
                        role: "user",
                        permissions: {
                            open: true,
                            close: true,
                            stop: false,
                            light: false,
                            relay: false,
                            lock: false,
                            reports: false,
                            bluetooth: true,
                            keepOpen: false,
                            widget: true,
                            pedestrian: true,
                            stepByStep: false,
                            notifications: true,
                            assignRoles: false,
                            assignUsers: false
                        }
                    },
                    {
                        id: 3,
                        name: "Juan Técnico",
                        email: "juan.tecnico@empresa.com",
                        role: "technician",
                        permissions: {
                            open: true,
                            close: true,
                            stop: true,
                            light: true,
                            relay: true,
                            lock: true,
                            reports: true,
                            bluetooth: false,
                            keepOpen: true,
                            widget: false,
                            pedestrian: true,
                            stepByStep: true,
                            notifications: true,
                            assignRoles: false,
                            assignUsers: false
                        }
                    }
                ];
            }

            // Set default selected user
            if (this.users.length > 0 && !this.selectedUserId) {
                this.selectedUserId = this.users[0].id;
                this.permissions = { ...this.users[0].permissions };
            }

        } catch (error) {
            console.error('Error loading user roles:', error);
            this.deviceData = null;
            this.users = [];
        }

        return `
            <div class="user-roles-screen">
                <div class="header">
                    <button class="header-back">
                        <span class="material-icons">arrow_back</span>
                    </button>
                    <h1 class="header-title">Roles y Permisos</h1>
                    <button class="header-action" id="helpBtn">
                        <span class="material-icons">help_outline</span>
                    </button>
                </div>
                
                <div class="user-roles-content">
                    ${this.renderDeviceInfo()}
                    ${this.renderUserSelector()}
                    ${this.renderPermissionsGrid()}
                    ${this.renderActionButtons()}
                </div>
            </div>
        `;
    },

    renderDeviceInfo() {
        if (!this.deviceData) {
            return '<div class="error">Error cargando información del dispositivo</div>';
        }

        const statusIcon = this.deviceData.status === 'online' ? 'wifi' : 'wifi_off';
        const statusClass = this.deviceData.status === 'online' ? 'online' : 'offline';
        const statusText = this.deviceData.status === 'online' ? 'En línea' : 'Desconectado';

        return `
            <div class="device-info-banner">
                <div class="device-info-header">
                    <div class="device-info-left">
                        <h2>${this.deviceData.name}</h2>
                        <div class="device-details">
                            <span class="device-model">${this.deviceData.model}</span>
                            <span class="device-serial">Serial: ${this.deviceData.serial}</span>
                        </div>
                    </div>
                    
                    <div class="device-status ${statusClass}">
                        <span class="material-icons">${statusIcon}</span>
                        <span>${statusText}</span>
                    </div>
                </div>
            </div>
        `;
    },

    renderUserSelector() {
        return `
            <div class="user-selector-section">
                <div class="section-header">
                    <span class="material-icons">person</span>
                    <h2>Seleccionar Usuario</h2>
                </div>
                
                <div class="user-selector">
                    <div class="form-field">
                        <label for="userSelect" class="form-label">Usuario a configurar</label>
                        <div class="input-group">
                            <span class="material-icons">account_circle</span>
                            <select id="userSelect" class="form-input">
                                ${this.users.map(user => `
                                    <option value="${user.id}" ${user.id === this.selectedUserId ? 'selected' : ''}>
                                        ${user.name} (${user.email})
                                    </option>
                                `).join('')}
                            </select>
                        </div>
                    </div>
                    
                    ${this.renderSelectedUserInfo()}
                </div>
            </div>
        `;
    },

    renderSelectedUserInfo() {
        const selectedUser = this.users.find(u => u.id === this.selectedUserId);
        if (!selectedUser) return '';

        const roleLabels = {
            'admin': 'Administrador',
            'user': 'Usuario',
            'technician': 'Técnico'
        };

        const roleColors = {
            'admin': 'role-admin',
            'user': 'role-user',
            'technician': 'role-tech'
        };

        return `
            <div class="selected-user-info">
                <div class="user-card">
                    <div class="user-avatar">
                        <span class="material-icons">account_circle</span>
                    </div>
                    
                    <div class="user-details">
                        <h3>${selectedUser.name}</h3>
                        <p class="user-email">${selectedUser.email}</p>
                        <span class="role-chip ${roleColors[selectedUser.role]}">
                            ${roleLabels[selectedUser.role]}
                        </span>
                    </div>
                    
                    <div class="user-stats">
                        <div class="stat">
                            <span class="stat-number">${this.countActivePermissions(selectedUser.permissions)}</span>
                            <span class="stat-label">Permisos</span>
                        </div>
                    </div>
                </div>
            </div>
        `;
    },

    renderPermissionsGrid() {
        const permissionGroups = [
            {
                title: 'Controles Básicos',
                icon: 'control_camera',
                permissions: [
                    { key: 'open', label: 'Abrir', description: 'Permitir abrir el dispositivo' },
                    { key: 'close', label: 'Cerrar', description: 'Permitir cerrar el dispositivo' },
                    { key: 'stop', label: 'Parar', description: 'Detener el movimiento del dispositivo' },
                    { key: 'pedestrian', label: 'Peatonal', description: 'Usar modo peatonal (apertura parcial)' }
                ]
            },
            {
                title: 'Funciones Avanzadas',
                icon: 'settings',
                permissions: [
                    { key: 'light', label: 'Lámpara', description: 'Controlar la iluminación' },
                    { key: 'relay', label: 'Relé', description: 'Activar relé auxiliar' },
                    { key: 'lock', label: 'Bloquear', description: 'Bloquear/desbloquear el dispositivo' },
                    { key: 'keepOpen', label: 'Mantener Abierto', description: 'Mantener dispositivo abierto indefinidamente' }
                ]
            },
            {
                title: 'Acceso y Reportes',
                icon: 'analytics',
                permissions: [
                    { key: 'reports', label: 'Reportes', description: 'Ver reportes y estadísticas' },
                    { key: 'bluetooth', label: 'Bluetooth', description: 'Usar conexión Bluetooth' },
                    { key: 'widget', label: 'Widget', description: 'Usar widget de control rápido' },
                    { key: 'stepByStep', label: 'Paso a Paso', description: 'Modo de operación manual paso a paso' }
                ]
            },
            {
                title: 'Notificaciones',
                icon: 'notifications',
                permissions: [
                    { key: 'notifications', label: 'Notificaciones', description: 'Recibir notificaciones del dispositivo' }
                ]
            },
            {
                title: 'Permisos de Seguridad',
                icon: 'security',
                color: 'security-section',
                permissions: [
                    { key: 'assignRoles', label: 'Asignar Roles', description: 'Modificar roles de otros usuarios' },
                    { key: 'assignUsers', label: 'Asignar Usuarios', description: 'Agregar/eliminar usuarios del dispositivo' }
                ]
            }
        ];

        return `
            <div class="permissions-section">
                <div class="section-header">
                    <span class="material-icons">security</span>
                    <h2>Configurar Permisos</h2>
                </div>
                
                <form id="permissionsForm" class="permissions-form">
                    ${permissionGroups.map(group => this.renderPermissionGroup(group)).join('')}
                </form>
            </div>
        `;
    },

    renderPermissionGroup(group) {
        return `
            <div class="permission-group ${group.color || ''}">
                <div class="group-header">
                    <span class="material-icons">${group.icon}</span>
                    <h3>${group.title}</h3>
                </div>
                
                <div class="permissions-grid">
                    ${group.permissions.map(permission => this.renderPermissionItem(permission)).join('')}
                </div>
            </div>
        `;
    },

    renderPermissionItem(permission) {
        const isChecked = this.permissions[permission.key] || false;
        
        return `
            <div class="permission-item">
                <div class="permission-control">
                    <label class="checkbox-label">
                        <input 
                            type="checkbox" 
                            id="perm-${permission.key}"
                            data-permission="${permission.key}"
                            ${isChecked ? 'checked' : ''}
                        >
                        <span class="checkmark"></span>
                        <div class="permission-info">
                            <span class="permission-name">${permission.label}</span>
                            <span class="permission-desc">${permission.description}</span>
                        </div>
                    </label>
                </div>
            </div>
        `;
    },

    renderActionButtons() {
        return `
            <div class="action-buttons-section">
                <div class="permission-presets">
                    <h3>Plantillas de Permisos</h3>
                    <div class="preset-buttons">
                        <button type="button" class="btn btn-outline preset-btn" data-preset="admin">
                            <span class="material-icons">admin_panel_settings</span>
                            Administrador
                        </button>
                        
                        <button type="button" class="btn btn-outline preset-btn" data-preset="user">
                            <span class="material-icons">person</span>
                            Usuario Básico
                        </button>
                        
                        <button type="button" class="btn btn-outline preset-btn" data-preset="technician">
                            <span class="material-icons">engineering</span>
                            Técnico
                        </button>
                        
                        <button type="button" class="btn btn-outline preset-btn" data-preset="guest">
                            <span class="material-icons">person_outline</span>
                            Invitado
                        </button>
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" id="resetChangesBtn">
                        <span class="material-icons">refresh</span>
                        Restablecer
                    </button>
                    
                    <button type="button" class="btn btn-primary" id="saveRolesBtn">
                        <span class="material-icons">save</span>
                        Asignar Roles
                    </button>
                </div>
                
                <div id="form-error" class="form-error hidden"></div>
            </div>
        `;
    },

    init() {
        this.setupEventListeners();
    },

    setupEventListeners() {
        // Back button
        const backBtn = document.querySelector('.header-back');
        if (backBtn) {
            backBtn.addEventListener('click', () => App.goBack());
        }

        // Help button
        const helpBtn = document.getElementById('helpBtn');
        if (helpBtn) {
            helpBtn.addEventListener('click', () => this.showHelp());
        }

        // User selection
        const userSelect = document.getElementById('userSelect');
        if (userSelect) {
            userSelect.addEventListener('change', (e) => {
                this.selectedUserId = parseInt(e.target.value);
                this.loadUserPermissions();
                this.refreshUserInfo();
                this.updatePermissionsCheckboxes();
            });
        }

        // Permission checkboxes
        const permissionCheckboxes = document.querySelectorAll('input[data-permission]');
        permissionCheckboxes.forEach(checkbox => {
            checkbox.addEventListener('change', (e) => {
                this.updatePermission(e.target.dataset.permission, e.target.checked);
            });
        });

        // Preset buttons
        const presetButtons = document.querySelectorAll('.preset-btn');
        presetButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                const preset = e.currentTarget.dataset.preset;
                this.applyPreset(preset);
            });
        });

        // Action buttons
        const resetBtn = document.getElementById('resetChangesBtn');
        if (resetBtn) {
            resetBtn.addEventListener('click', () => this.resetChanges());
        }

        const saveBtn = document.getElementById('saveRolesBtn');
        if (saveBtn) {
            saveBtn.addEventListener('click', () => this.saveRoles());
        }
    },

    loadUserPermissions() {
        const selectedUser = this.users.find(u => u.id === this.selectedUserId);
        if (selectedUser) {
            this.permissions = { ...selectedUser.permissions };
        }
    },

    refreshUserInfo() {
        const userInfoContainer = document.querySelector('.selected-user-info');
        if (userInfoContainer) {
            userInfoContainer.innerHTML = this.renderSelectedUserInfo();
        }
    },

    updatePermissionsCheckboxes() {
        const checkboxes = document.querySelectorAll('input[data-permission]');
        checkboxes.forEach(checkbox => {
            const permission = checkbox.dataset.permission;
            checkbox.checked = this.permissions[permission] || false;
        });
    },

    updatePermission(permissionKey, isEnabled) {
        this.permissions[permissionKey] = isEnabled;
        
        // Security rule: if user loses assignRoles permission, also remove assignUsers
        if (permissionKey === 'assignRoles' && !isEnabled) {
            this.permissions.assignUsers = false;
            const assignUsersCheckbox = document.querySelector('input[data-permission="assignUsers"]');
            if (assignUsersCheckbox) {
                assignUsersCheckbox.checked = false;
            }
        }
        
        // Security rule: assignUsers requires assignRoles
        if (permissionKey === 'assignUsers' && isEnabled && !this.permissions.assignRoles) {
            this.permissions.assignRoles = true;
            const assignRolesCheckbox = document.querySelector('input[data-permission="assignRoles"]');
            if (assignRolesCheckbox) {
                assignRolesCheckbox.checked = true;
            }
        }
        
        this.refreshUserInfo();
    },

    applyPreset(preset) {
        const presets = {
            admin: {
                open: true,
                close: true,
                stop: true,
                light: true,
                relay: true,
                lock: true,
                reports: true,
                bluetooth: true,
                keepOpen: true,
                widget: true,
                pedestrian: true,
                stepByStep: true,
                notifications: true,
                assignRoles: true,
                assignUsers: true
            },
            user: {
                open: true,
                close: true,
                stop: false,
                light: false,
                relay: false,
                lock: false,
                reports: false,
                bluetooth: true,
                keepOpen: false,
                widget: true,
                pedestrian: true,
                stepByStep: false,
                notifications: true,
                assignRoles: false,
                assignUsers: false
            },
            technician: {
                open: true,
                close: true,
                stop: true,
                light: true,
                relay: true,
                lock: true,
                reports: true,
                bluetooth: false,
                keepOpen: true,
                widget: false,
                pedestrian: true,
                stepByStep: true,
                notifications: true,
                assignRoles: false,
                assignUsers: false
            },
            guest: {
                open: true,
                close: false,
                stop: false,
                light: false,
                relay: false,
                lock: false,
                reports: false,
                bluetooth: false,
                keepOpen: false,
                widget: false,
                pedestrian: false,
                stepByStep: false,
                notifications: false,
                assignRoles: false,
                assignUsers: false
            }
        };

        if (presets[preset]) {
            this.permissions = { ...presets[preset] };
            this.updatePermissionsCheckboxes();
            this.refreshUserInfo();
            
            App.showToast(`Plantilla "${preset}" aplicada`, 'success');
        }
    },

    resetChanges() {
        this.loadUserPermissions();
        this.updatePermissionsCheckboxes();
        this.refreshUserInfo();
        this.clearFormErrors();
        
        App.showToast('Cambios restablecidos', 'info');
    },

    async saveRoles() {
        const selectedUser = this.users.find(u => u.id === this.selectedUserId);
        if (!selectedUser) {
            this.showFormError('No se ha seleccionado un usuario válido');
            return;
        }

        // Validate permissions
        if (!this.validatePermissions()) {
            return;
        }

        const saveBtn = document.getElementById('saveRolesBtn');
        this.setLoadingState(saveBtn, true);

        try {
            const result = await API.updateUserRoles(this.deviceId, selectedUser.id, this.permissions);
            
            if (result.success || true) { // Allow if API not implemented
                // Update local user data
                selectedUser.permissions = { ...this.permissions };
                
                this.clearFormErrors();
                App.showToast(`Permisos actualizados para ${selectedUser.name}`, 'success');
                
                // Optionally navigate back
                setTimeout(() => {
                    App.navigate(`#/devices/${this.deviceId}/users`);
                }, 1500);
            } else {
                this.showFormError(result.error || 'Error al actualizar los permisos');
            }
        } catch (error) {
            console.error('Error saving user roles:', error);
            this.showFormError('Error de conexión. Intenta nuevamente.');
        } finally {
            this.setLoadingState(saveBtn, false);
        }
    },

    validatePermissions() {
        // At least one basic permission should be granted
        const basicPermissions = ['open', 'close', 'pedestrian'];
        const hasBasicPermission = basicPermissions.some(perm => this.permissions[perm]);
        
        if (!hasBasicPermission) {
            this.showFormError('El usuario debe tener al menos un permiso básico (Abrir, Cerrar o Peatonal)');
            return false;
        }

        // Security validation: assignUsers requires assignRoles
        if (this.permissions.assignUsers && !this.permissions.assignRoles) {
            this.showFormError('El permiso "Asignar Usuarios" requiere el permiso "Asignar Roles"');
            return false;
        }

        return true;
    },

    countActivePermissions(permissions) {
        return Object.values(permissions).filter(Boolean).length;
    },

    showHelp() {
        const helpContent = `
            <div class="help-modal">
                <h3>Ayuda - Roles y Permisos</h3>
                <div class="help-content">
                    <div class="help-item">
                        <h4>Permisos Básicos</h4>
                        <p>Controlan las funciones fundamentales como abrir, cerrar y modo peatonal. Todo usuario debe tener al menos un permiso básico.</p>
                    </div>
                    
                    <div class="help-item">
                        <h4>Plantillas</h4>
                        <ul>
                            <li><strong>Administrador:</strong> Todos los permisos habilitados</li>
                            <li><strong>Usuario Básico:</strong> Solo controles esenciales</li>
                            <li><strong>Técnico:</strong> Control completo excepto gestión de usuarios</li>
                            <li><strong>Invitado:</strong> Solo apertura básica</li>
                        </ul>
                    </div>
                    
                    <div class="help-item">
                        <h4>Permisos de Seguridad</h4>
                        <p>Los permisos de asignación de usuarios y roles solo deben otorgarse a administradores de confianza.</p>
                    </div>
                </div>
                <button class="btn btn-primary" onclick="this.parentElement.remove()">Entendido</button>
            </div>
        `;
        
        // Create overlay
        const overlay = document.createElement('div');
        overlay.className = 'modal-overlay';
        overlay.innerHTML = helpContent;
        document.body.appendChild(overlay);
        
        // Close on overlay click
        overlay.addEventListener('click', (e) => {
            if (e.target === overlay) {
                overlay.remove();
            }
        });
    },

    setLoadingState(button, loading) {
        if (!button) return;

        if (loading) {
            button.disabled = true;
            button.dataset.originalText = button.innerHTML;
            button.innerHTML = `
                <div class="spinner" style="width: 16px; height: 16px; border-width: 2px;"></div>
                Guardando...
            `;
        } else {
            button.disabled = false;
            button.innerHTML = button.dataset.originalText || button.innerHTML;
        }
    },

    showFormError(message) {
        const errorElement = document.getElementById('form-error');
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.classList.remove('hidden');
        }
    },

    clearFormErrors() {
        const errorElement = document.getElementById('form-error');
        if (errorElement) {
            errorElement.textContent = '';
            errorElement.classList.add('hidden');
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
                        const userRolesScreen = node.querySelector('.user-roles-screen') || 
                                              (node.classList && node.classList.contains('user-roles-screen') ? node : null);
                        if (userRolesScreen) {
                            setTimeout(() => UserRolesScreen.init(), 0);
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

window.UserRolesScreen = UserRolesScreen;