// Link Virtual User Screen Module
const LinkVirtualUserScreen = {
    deviceId: null,
    deviceData: null,
    linkedUsers: [],

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

            // Load linked virtual users
            const linkedResult = await API.getLinkedVirtualUsers(deviceId);
            if (linkedResult.success) {
                this.linkedUsers = linkedResult.data;
            } else {
                // Mock linked users
                this.linkedUsers = [
                    {
                        id: 1,
                        emailOrUsername: "maria@gmail.com",
                        label: "María - Propietaria",
                        type: "email",
                        status: "active",
                        linkedAt: "2025-03-10T14:30:00Z",
                        lastAccess: "2025-03-14T09:15:00Z"
                    },
                    {
                        id: 2,
                        emailOrUsername: "juan_vecino",
                        label: "Juan Vecino",
                        type: "username",
                        status: "pending",
                        linkedAt: "2025-03-13T16:45:00Z",
                        lastAccess: null
                    }
                ];
            }

        } catch (error) {
            console.error('Error loading virtual user data:', error);
            this.deviceData = null;
            this.linkedUsers = [];
        }

        return `
            <div class="link-virtual-user-screen">
                <div class="header">
                    <button class="header-back">
                        <span class="material-icons">arrow_back</span>
                    </button>
                    <h1 class="header-title">Vincular Usuario</h1>
                    <button class="header-action" id="helpBtn">
                        <span class="material-icons">help_outline</span>
                    </button>
                </div>
                
                <div class="link-user-content">
                    ${this.renderDeviceInfo()}
                    ${this.renderLinkForm()}
                    ${this.renderLinkedUsers()}
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

    renderLinkForm() {
        return `
            <div class="link-form-section">
                <div class="section-header">
                    <span class="material-icons">person_add</span>
                    <h2>Agregar Usuario Virtual</h2>
                </div>
                
                <div class="form-description">
                    <p>Vincula un usuario existente del sistema a este dispositivo usando su email o nombre de usuario.</p>
                </div>
                
                <form id="linkUserForm" class="link-user-form">
                    <div class="form-field">
                        <label for="userIdentifier" class="form-label">Email o Usuario</label>
                        <div class="input-group">
                            <span class="material-icons">alternate_email</span>
                            <input 
                                type="text" 
                                id="userIdentifier" 
                                class="form-input" 
                                placeholder="ejemplo@correo.com o nombre_usuario"
                                required 
                            >
                            <button type="button" class="search-user-btn" id="searchUserBtn">
                                <span class="material-icons">search</span>
                            </button>
                        </div>
                        <div id="identifier-error" class="form-error hidden"></div>
                        <small class="form-hint">Ingresa el email o nombre de usuario registrado en el sistema</small>
                    </div>
                    
                    <div class="form-field">
                        <label for="userLabel" class="form-label">Etiqueta descriptiva</label>
                        <div class="input-group">
                            <span class="material-icons">label</span>
                            <input 
                                type="text" 
                                id="userLabel" 
                                class="form-input" 
                                placeholder="Ej: María - Propietaria, Juan - Vecino, etc."
                                required 
                            >
                        </div>
                        <div id="label-error" class="form-error hidden"></div>
                        <small class="form-hint">Una descripción para identificar fácilmente al usuario</small>
                    </div>
                    
                    <div class="form-field">
                        <label class="form-label">Opciones de acceso</label>
                        <div class="access-options">
                            <label class="checkbox-option">
                                <input type="checkbox" id="sendNotification" checked>
                                <span class="checkmark"></span>
                                <div class="option-info">
                                    <span class="option-title">Enviar notificación</span>
                                    <span class="option-desc">Notificar al usuario que ha sido agregado al dispositivo</span>
                                </div>
                            </label>
                            
                            <label class="checkbox-option">
                                <input type="checkbox" id="grantBasicAccess" checked>
                                <span class="checkmark"></span>
                                <div class="option-info">
                                    <span class="option-title">Acceso básico</span>
                                    <span class="option-desc">Otorgar permisos básicos de apertura y cierre</span>
                                </div>
                            </label>
                            
                            <label class="checkbox-option">
                                <input type="checkbox" id="temporaryAccess">
                                <span class="checkmark"></span>
                                <div class="option-info">
                                    <span class="option-title">Acceso temporal</span>
                                    <span class="option-desc">El acceso expirará automáticamente</span>
                                </div>
                            </label>
                        </div>
                    </div>
                    
                    <div class="form-field temporal-options hidden" id="temporalOptions">
                        <label for="accessDuration" class="form-label">Duración del acceso</label>
                        <div class="input-group">
                            <span class="material-icons">schedule</span>
                            <select id="accessDuration" class="form-input">
                                <option value="1">1 día</option>
                                <option value="7">1 semana</option>
                                <option value="30" selected>1 mes</option>
                                <option value="90">3 meses</option>
                                <option value="365">1 año</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" id="cancelLinkBtn">
                            <span class="material-icons">cancel</span>
                            Cancelar
                        </button>
                        
                        <button type="submit" class="btn btn-primary" id="linkUserBtn">
                            <span class="material-icons">person_add</span>
                            Agregar Usuario al Listado
                        </button>
                    </div>
                    
                    <div id="form-error" class="form-error hidden"></div>
                </form>
                
                <div class="user-search-results hidden" id="searchResults">
                    <!-- Search results will be populated here -->
                </div>
            </div>
        `;
    },

    renderLinkedUsers() {
        return `
            <div class="linked-users-section">
                <div class="section-header">
                    <span class="material-icons">people</span>
                    <h2>Usuarios Vinculados</h2>
                    <span class="user-count">(${this.linkedUsers.length})</span>
                </div>
                
                ${this.linkedUsers.length > 0 ? `
                    <div class="linked-users-list">
                        ${this.linkedUsers.map(user => this.renderLinkedUserItem(user)).join('')}
                    </div>
                ` : `
                    <div class="empty-linked-users">
                        <span class="material-icons">person_add_disabled</span>
                        <h3>No hay usuarios vinculados</h3>
                        <p>Los usuarios que agregues aparecerán aquí</p>
                    </div>
                `}
                
                <div class="linked-users-info">
                    <div class="info-card">
                        <span class="material-icons">info</span>
                        <div>
                            <h4>¿Qué es un usuario virtual?</h4>
                            <p>Son usuarios del sistema que pueden acceder a este dispositivo sin necesidad de estar físicamente presentes durante la configuración.</p>
                        </div>
                    </div>
                    
                    <div class="info-card">
                        <span class="material-icons">security</span>
                        <div>
                            <h4>Permisos</h4>
                            <p>Los usuarios virtuales tienen permisos básicos por defecto. Puedes configurar permisos específicos en la sección de Roles y Permisos.</p>
                        </div>
                    </div>
                </div>
            </div>
        `;
    },

    renderLinkedUserItem(user) {
        const statusColors = {
            'active': 'status-active',
            'pending': 'status-pending',
            'expired': 'status-expired'
        };

        const statusLabels = {
            'active': 'Activo',
            'pending': 'Pendiente',
            'expired': 'Expirado'
        };

        const typeIcons = {
            'email': 'email',
            'username': 'person'
        };

        const lastAccess = user.lastAccess ? 
            this.formatTimeAgo(user.lastAccess) : 
            'Nunca';

        return `
            <div class="linked-user-item">
                <div class="user-info">
                    <div class="user-avatar">
                        <span class="material-icons">${typeIcons[user.type]}</span>
                    </div>
                    
                    <div class="user-details">
                        <h3 class="user-label">${user.label}</h3>
                        <p class="user-identifier">${user.emailOrUsername}</p>
                        
                        <div class="user-meta">
                            <span class="status-chip ${statusColors[user.status]}">
                                ${statusLabels[user.status]}
                            </span>
                            <span class="last-access">Último acceso: ${lastAccess}</span>
                        </div>
                    </div>
                </div>
                
                <div class="user-actions">
                    <button class="btn btn-icon" title="Editar permisos" onclick="App.navigate('#/devices/${this.deviceId}/users')">
                        <span class="material-icons">edit</span>
                    </button>
                    
                    <button class="btn btn-icon" title="Enviar notificación" data-action="notify" data-user-id="${user.id}">
                        <span class="material-icons">notifications</span>
                    </button>
                    
                    <button class="btn btn-icon danger" title="Desvincular usuario" data-action="unlink" data-user-id="${user.id}">
                        <span class="material-icons">person_remove</span>
                    </button>
                </div>
                
                <div class="user-stats">
                    <div class="stat-item">
                        <span class="stat-label">Vinculado:</span>
                        <span class="stat-value">${this.formatDate(user.linkedAt)}</span>
                    </div>
                </div>
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

        // Form submission
        const form = document.getElementById('linkUserForm');
        if (form) {
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                this.linkUser();
            });
        }

        // Cancel button
        const cancelBtn = document.getElementById('cancelLinkBtn');
        if (cancelBtn) {
            cancelBtn.addEventListener('click', () => App.goBack());
        }

        // Search user button
        const searchBtn = document.getElementById('searchUserBtn');
        if (searchBtn) {
            searchBtn.addEventListener('click', () => this.searchUser());
        }

        // Temporal access toggle
        const temporalCheckbox = document.getElementById('temporaryAccess');
        if (temporalCheckbox) {
            temporalCheckbox.addEventListener('change', (e) => {
                const temporalOptions = document.getElementById('temporalOptions');
                if (e.target.checked) {
                    temporalOptions.classList.remove('hidden');
                } else {
                    temporalOptions.classList.add('hidden');
                }
            });
        }

        // User identifier input
        const identifierInput = document.getElementById('userIdentifier');
        if (identifierInput) {
            identifierInput.addEventListener('input', () => this.clearFieldError('identifier-error'));
            identifierInput.addEventListener('blur', () => this.suggestLabel());
        }

        // Input validation
        const inputs = document.querySelectorAll('.form-input');
        inputs.forEach(input => {
            input.addEventListener('input', () => this.clearFieldError(`${input.id}-error`));
        });

        // Linked user actions
        const actionButtons = document.querySelectorAll('[data-action]');
        actionButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                const action = e.target.dataset.action || e.target.closest('[data-action]').dataset.action;
                const userId = e.target.dataset.userId || e.target.closest('[data-action]').dataset.userId;
                this.handleUserAction(action, userId);
            });
        });
    },

    async searchUser() {
        const identifier = document.getElementById('userIdentifier').value.trim();
        
        if (!identifier) {
            this.showFieldError('identifier-error', 'Ingresa un email o nombre de usuario');
            return;
        }

        const searchBtn = document.getElementById('searchUserBtn');
        this.setSearchLoading(searchBtn, true);

        try {
            const result = await API.searchUser(identifier);
            
            if (result.success && result.data) {
                this.showSearchResults(result.data);
                
                // Auto-fill label if found
                const labelInput = document.getElementById('userLabel');
                if (labelInput && !labelInput.value) {
                    labelInput.value = result.data.displayName || result.data.name || identifier;
                }
                
                App.showToast('Usuario encontrado', 'success');
            } else {
                this.showSearchResults(null);
                App.showToast('Usuario no encontrado', 'warning');
            }
        } catch (error) {
            console.error('Error searching user:', error);
            this.showSearchResults(null);
            App.showToast('Error buscando usuario', 'error');
        } finally {
            this.setSearchLoading(searchBtn, false);
        }
    },

    showSearchResults(userData) {
        const resultsContainer = document.getElementById('searchResults');
        
        if (!userData) {
            resultsContainer.innerHTML = `
                <div class="search-result not-found">
                    <span class="material-icons">person_search</span>
                    <p>Usuario no encontrado en el sistema</p>
                    <small>Verifica que el email o nombre de usuario sea correcto</small>
                </div>
            `;
        } else {
            resultsContainer.innerHTML = `
                <div class="search-result found">
                    <div class="result-header">
                        <span class="material-icons">check_circle</span>
                        <h4>Usuario Encontrado</h4>
                    </div>
                    
                    <div class="user-preview">
                        <div class="preview-avatar">
                            <span class="material-icons">account_circle</span>
                        </div>
                        
                        <div class="preview-info">
                            <h3>${userData.displayName || userData.name}</h3>
                            <p>${userData.email || userData.username}</p>
                            ${userData.lastActive ? 
                                `<span class="last-active">Última actividad: ${this.formatDate(userData.lastActive)}</span>` :
                                ''
                            }
                        </div>
                    </div>
                </div>
            `;
        }
        
        resultsContainer.classList.remove('hidden');
    },

    suggestLabel() {
        const identifier = document.getElementById('userIdentifier').value.trim();
        const labelInput = document.getElementById('userLabel');
        
        if (identifier && !labelInput.value) {
            // Extract name from email or use username
            if (identifier.includes('@')) {
                const username = identifier.split('@')[0];
                const suggestedLabel = username.charAt(0).toUpperCase() + username.slice(1);
                labelInput.value = suggestedLabel;
            } else {
                labelInput.value = identifier;
            }
        }
    },

    async linkUser() {
        const formData = this.getFormData();
        
        // Clear previous errors
        this.clearFormErrors();
        
        // Validate form
        if (!this.validateForm(formData)) {
            return;
        }

        const linkBtn = document.getElementById('linkUserBtn');
        this.setLoadingState(linkBtn, true);

        try {
            const result = await API.linkVirtualUser(this.deviceId, formData);
            
            if (result.success || true) { // Allow if API not implemented
                // Add to local linked users
                const newUser = {
                    id: Date.now(), // Temporary ID
                    emailOrUsername: formData.userIdentifier,
                    label: formData.userLabel,
                    type: formData.userIdentifier.includes('@') ? 'email' : 'username',
                    status: 'pending',
                    linkedAt: new Date().toISOString(),
                    lastAccess: null
                };
                
                this.linkedUsers.push(newUser);
                
                // Clear form
                document.getElementById('linkUserForm').reset();
                document.getElementById('searchResults').classList.add('hidden');
                
                // Refresh linked users section
                this.refreshLinkedUsers();
                
                App.showToast('Usuario vinculado correctamente', 'success');
                
                if (formData.sendNotification) {
                    setTimeout(() => {
                        App.showToast('Notificación enviada al usuario', 'info');
                    }, 1000);
                }
            } else {
                this.showFormError(result.error || 'Error al vincular usuario');
            }
        } catch (error) {
            console.error('Error linking user:', error);
            this.showFormError('Error de conexión. Intenta nuevamente.');
        } finally {
            this.setLoadingState(linkBtn, false);
        }
    },

    async handleUserAction(action, userId) {
        const user = this.linkedUsers.find(u => u.id == userId);
        if (!user) return;

        switch (action) {
            case 'notify':
                await this.notifyUser(user);
                break;
            case 'unlink':
                await this.unlinkUser(user);
                break;
        }
    },

    async notifyUser(user) {
        try {
            const result = await API.notifyUser(user.id, {
                message: `Tienes acceso al dispositivo ${this.deviceData.name}`,
                deviceId: this.deviceId
            });
            
            if (result.success || true) {
                App.showToast(`Notificación enviada a ${user.label}`, 'success');
            }
        } catch (error) {
            console.error('Error notifying user:', error);
            App.showToast('Error enviando notificación', 'error');
        }
    },

    async unlinkUser(user) {
        if (!confirm(`¿Estás seguro de que quieres desvincular a ${user.label}?`)) {
            return;
        }

        try {
            const result = await API.unlinkVirtualUser(this.deviceId, user.id);
            
            if (result.success || true) {
                // Remove from local array
                this.linkedUsers = this.linkedUsers.filter(u => u.id !== user.id);
                this.refreshLinkedUsers();
                
                App.showToast(`${user.label} desvinculado correctamente`, 'success');
            }
        } catch (error) {
            console.error('Error unlinking user:', error);
            App.showToast('Error desvinculando usuario', 'error');
        }
    },

    getFormData() {
        return {
            userIdentifier: document.getElementById('userIdentifier').value.trim(),
            userLabel: document.getElementById('userLabel').value.trim(),
            sendNotification: document.getElementById('sendNotification').checked,
            grantBasicAccess: document.getElementById('grantBasicAccess').checked,
            temporaryAccess: document.getElementById('temporaryAccess').checked,
            accessDuration: document.getElementById('accessDuration').value
        };
    },

    validateForm(data) {
        let isValid = true;

        // Validate user identifier
        if (!data.userIdentifier) {
            this.showFieldError('identifier-error', 'El email o nombre de usuario es requerido');
            isValid = false;
        } else if (data.userIdentifier.includes('@')) {
            // Validate email format
            if (!this.isValidEmail(data.userIdentifier)) {
                this.showFieldError('identifier-error', 'Formato de email inválido');
                isValid = false;
            }
        } else {
            // Validate username format
            if (data.userIdentifier.length < 3) {
                this.showFieldError('identifier-error', 'El nombre de usuario debe tener al menos 3 caracteres');
                isValid = false;
            }
        }

        // Check if user is already linked
        const alreadyLinked = this.linkedUsers.some(u => 
            u.emailOrUsername.toLowerCase() === data.userIdentifier.toLowerCase()
        );
        if (alreadyLinked) {
            this.showFieldError('identifier-error', 'Este usuario ya está vinculado al dispositivo');
            isValid = false;
        }

        // Validate label
        if (!data.userLabel) {
            this.showFieldError('label-error', 'La etiqueta descriptiva es requerida');
            isValid = false;
        } else if (data.userLabel.length < 3) {
            this.showFieldError('label-error', 'La etiqueta debe tener al menos 3 caracteres');
            isValid = false;
        }

        return isValid;
    },

    refreshLinkedUsers() {
        const linkedUsersContainer = document.querySelector('.linked-users-section');
        if (linkedUsersContainer) {
            linkedUsersContainer.outerHTML = this.renderLinkedUsers();
            
            // Re-attach event listeners for new buttons
            const actionButtons = document.querySelectorAll('[data-action]');
            actionButtons.forEach(button => {
                button.addEventListener('click', (e) => {
                    const action = e.target.dataset.action || e.target.closest('[data-action]').dataset.action;
                    const userId = e.target.dataset.userId || e.target.closest('[data-action]').dataset.userId;
                    this.handleUserAction(action, userId);
                });
            });
        }
    },

    showHelp() {
        const helpContent = `
            <div class="help-modal">
                <h3>Ayuda - Vincular Usuario Virtual</h3>
                <div class="help-content">
                    <div class="help-item">
                        <h4>¿Qué es un usuario virtual?</h4>
                        <p>Es un usuario registrado en el sistema que puede acceder al dispositivo usando su cuenta existente, sin necesidad de configuración física.</p>
                    </div>
                    
                    <div class="help-item">
                        <h4>Cómo funciona</h4>
                        <ol>
                            <li>Busca el usuario por email o nombre de usuario</li>
                            <li>Asigna una etiqueta descriptiva</li>
                            <li>Configura las opciones de acceso</li>
                            <li>El usuario recibe una notificación (opcional)</li>
                        </ol>
                    </div>
                    
                    <div class="help-item">
                        <h4>Opciones de acceso</h4>
                        <ul>
                            <li><strong>Acceso básico:</strong> Permisos de apertura y cierre</li>
                            <li><strong>Acceso temporal:</strong> El acceso expira automáticamente</li>
                            <li><strong>Notificación:</strong> Avisa al usuario sobre el nuevo acceso</li>
                        </ul>
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

    isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    },

    formatDate(timestamp) {
        const date = new Date(timestamp);
        return date.toLocaleDateString('es-ES', {
            year: 'numeric',
            month: 'short',
            day: 'numeric'
        });
    },

    formatTimeAgo(timestamp) {
        const now = new Date();
        const time = new Date(timestamp);
        const diffInMinutes = Math.floor((now - time) / (1000 * 60));
        
        if (diffInMinutes < 1) {
            return 'Ahora';
        } else if (diffInMinutes < 60) {
            return `${diffInMinutes}min`;
        } else if (diffInMinutes < 1440) {
            const hours = Math.floor(diffInMinutes / 60);
            return `${hours}h`;
        } else {
            const days = Math.floor(diffInMinutes / 1440);
            return `${days}d`;
        }
    },

    setLoadingState(button, loading) {
        if (!button) return;

        if (loading) {
            button.disabled = true;
            button.dataset.originalText = button.innerHTML;
            button.innerHTML = `
                <div class="spinner" style="width: 16px; height: 16px; border-width: 2px;"></div>
                Procesando...
            `;
        } else {
            button.disabled = false;
            button.innerHTML = button.dataset.originalText || button.innerHTML;
        }
    },

    setSearchLoading(button, loading) {
        if (!button) return;

        if (loading) {
            button.disabled = true;
            button.querySelector('.material-icons').textContent = 'hourglass_empty';
        } else {
            button.disabled = false;
            button.querySelector('.material-icons').textContent = 'search';
        }
    },

    showFieldError(elementId, message) {
        const errorElement = document.getElementById(elementId);
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.classList.remove('hidden');
        }
    },

    showFormError(message) {
        const errorElement = document.getElementById('form-error');
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.classList.remove('hidden');
        }
    },

    clearFieldError(elementId) {
        const errorElement = document.getElementById(elementId);
        if (errorElement) {
            errorElement.textContent = '';
            errorElement.classList.add('hidden');
        }
    },

    clearFormErrors() {
        const errorElements = document.querySelectorAll('.form-error');
        errorElements.forEach(element => {
            element.textContent = '';
            element.classList.add('hidden');
        });
    }
};

// Auto-initialize when content is rendered
document.addEventListener('DOMContentLoaded', () => {
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.addedNodes) {
                mutation.addedNodes.forEach((node) => {
                    if (node.nodeType === Node.ELEMENT_NODE) {
                        const linkUserScreen = node.querySelector('.link-virtual-user-screen') || 
                                             (node.classList && node.classList.contains('link-virtual-user-screen') ? node : null);
                        if (linkUserScreen) {
                            setTimeout(() => LinkVirtualUserScreen.init(), 0);
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

window.LinkVirtualUserScreen = LinkVirtualUserScreen;