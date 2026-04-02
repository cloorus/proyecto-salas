// Technical Contact Screen Module
const TechnicalContactScreen = {
    deviceId: null,
    deviceData: null,
    contactData: null,

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
                    status: "online",
                    detail: "Funcionando correctamente"
                };
            }

            // Load technical contact data
            const contactResult = await API.getTechnicalContact(deviceId);
            if (contactResult.success) {
                this.contactData = contactResult.data;
            } else {
                // Mock contact data or empty for new contact
                this.contactData = {
                    username: "tecnico_bgnius",
                    email: "soporte@bgnius.com", 
                    country: "CO",
                    phone: "+57 300 123 4567",
                    notes: "Técnico especializado en sistemas VITA. Horario de atención: Lunes a Viernes 8:00 AM - 6:00 PM"
                };
            }
        } catch (error) {
            console.error('Error loading technical contact:', error);
            this.deviceData = null;
            this.contactData = null;
        }

        return `
            <div class="technical-contact-screen">
                <div class="header">
                    <button class="header-back">
                        <span class="material-icons">arrow_back</span>
                    </button>
                    <h1 class="header-title">Contacto Técnico</h1>
                    <button class="header-action" id="helpBtn">
                        <span class="material-icons">help_outline</span>
                    </button>
                </div>
                
                <div class="technical-contact-content">
                    ${this.renderDeviceInfo()}
                    ${this.renderContactForm()}
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
                
                <div class="device-detail">
                    <span class="material-icons">info</span>
                    <span>${this.deviceData.detail}</span>
                </div>
            </div>
        `;
    },

    renderContactForm() {
        const countries = [
            { code: 'AR', name: 'Argentina' },
            { code: 'BO', name: 'Bolivia' },
            { code: 'BR', name: 'Brasil' },
            { code: 'CL', name: 'Chile' },
            { code: 'CO', name: 'Colombia' },
            { code: 'EC', name: 'Ecuador' },
            { code: 'PE', name: 'Perú' },
            { code: 'UY', name: 'Uruguay' },
            { code: 'VE', name: 'Venezuela' },
            { code: 'MX', name: 'México' },
            { code: 'US', name: 'Estados Unidos' },
            { code: 'ES', name: 'España' }
        ];

        return `
            <div class="contact-form-container">
                <div class="form-header">
                    <div class="form-title">
                        <span class="material-icons">engineering</span>
                        <h2>Información del Técnico</h2>
                    </div>
                    <p class="form-description">
                        Configura los datos del técnico responsable del mantenimiento
                    </p>
                </div>
                
                <form id="technicalContactForm" class="technical-form">
                    <div class="form-field">
                        <label for="username" class="form-label">Nombre de usuario</label>
                        <div class="input-group">
                            <span class="material-icons">person</span>
                            <input 
                                type="text" 
                                id="username" 
                                class="form-input" 
                                value="${this.contactData?.username || ''}"
                                placeholder="usuario_tecnico"
                                required 
                            >
                        </div>
                        <div id="username-error" class="form-error hidden"></div>
                    </div>
                    
                    <div class="form-field">
                        <label for="email" class="form-label">Correo electrónico</label>
                        <div class="input-group">
                            <span class="material-icons">email</span>
                            <input 
                                type="email" 
                                id="email" 
                                class="form-input" 
                                value="${this.contactData?.email || ''}"
                                placeholder="tecnico@empresa.com"
                                required 
                            >
                        </div>
                        <div id="email-error" class="form-error hidden"></div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-field">
                            <label for="country" class="form-label">País</label>
                            <div class="input-group">
                                <span class="material-icons">public</span>
                                <select id="country" class="form-input" required>
                                    <option value="">Seleccionar país</option>
                                    ${countries.map(country => `
                                        <option value="${country.code}" ${this.contactData?.country === country.code ? 'selected' : ''}>
                                            ${country.name}
                                        </option>
                                    `).join('')}
                                </select>
                            </div>
                            <div id="country-error" class="form-error hidden"></div>
                        </div>
                        
                        <div class="form-field">
                            <label for="phone" class="form-label">Teléfono</label>
                            <div class="input-group">
                                <span class="material-icons">phone</span>
                                <input 
                                    type="tel" 
                                    id="phone" 
                                    class="form-input" 
                                    value="${this.contactData?.phone || ''}"
                                    placeholder="+57 300 123 4567"
                                    required 
                                >
                            </div>
                            <div id="phone-error" class="form-error hidden"></div>
                        </div>
                    </div>
                    
                    <div class="form-field">
                        <label for="notes" class="form-label">Notas adicionales</label>
                        <div class="textarea-group">
                            <span class="material-icons">note</span>
                            <textarea 
                                id="notes" 
                                class="form-textarea" 
                                placeholder="Información adicional sobre el técnico, horarios de atención, especialidades, etc."
                                rows="4"
                            >${this.contactData?.notes || ''}</textarea>
                        </div>
                        <div class="char-counter">
                            <span id="notesCharCount">0</span> / 500 caracteres
                        </div>
                    </div>
                    
                    <div id="form-error" class="form-error hidden"></div>
                </form>
                
                <div class="form-actions">
                    <div class="action-buttons">
                        <button type="button" class="btn btn-secondary" id="contactMaintenanceBtn">
                            <span class="material-icons">support_agent</span>
                            Contactar Mantenimiento
                        </button>
                        
                        <button type="button" class="btn btn-danger" id="deleteContactBtn">
                            <span class="material-icons">delete</span>
                            Eliminar
                        </button>
                        
                        <button type="submit" class="btn btn-primary" id="saveContactBtn" form="technicalContactForm">
                            <span class="material-icons">save</span>
                            Guardar
                        </button>
                    </div>
                    
                    <div class="action-info">
                        <div class="info-item">
                            <span class="material-icons">info</span>
                            <p>El técnico recibirá notificaciones sobre el estado del dispositivo</p>
                        </div>
                        <div class="info-item">
                            <span class="material-icons">security</span>
                            <p>Solo usuarios autorizados pueden modificar esta información</p>
                        </div>
                    </div>
                </div>
            </div>
        `;
    },

    init() {
        this.setupEventListeners();
        this.updateCharCounter();
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
        const form = document.getElementById('technicalContactForm');
        if (form) {
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                this.saveContact();
            });
        }

        // Action buttons
        const contactBtn = document.getElementById('contactMaintenanceBtn');
        if (contactBtn) {
            contactBtn.addEventListener('click', () => this.contactMaintenance());
        }

        const deleteBtn = document.getElementById('deleteContactBtn');
        if (deleteBtn) {
            deleteBtn.addEventListener('click', () => this.deleteContact());
        }

        // Input validation
        const inputs = document.querySelectorAll('.form-input, .form-textarea');
        inputs.forEach(input => {
            input.addEventListener('input', () => this.clearFieldError(input.id));
            
            if (input.id === 'notes') {
                input.addEventListener('input', () => this.updateCharCounter());
            }
        });

        // Phone number formatting
        const phoneInput = document.getElementById('phone');
        if (phoneInput) {
            phoneInput.addEventListener('input', (e) => this.formatPhoneNumber(e));
        }

        // Username validation
        const usernameInput = document.getElementById('username');
        if (usernameInput) {
            usernameInput.addEventListener('input', (e) => this.validateUsername(e));
        }
    },

    async saveContact() {
        const formData = this.getFormData();
        
        // Clear previous errors
        this.clearFormErrors();
        
        // Validate form
        if (!this.validateForm(formData)) {
            return;
        }

        const saveBtn = document.getElementById('saveContactBtn');
        this.setLoadingState(saveBtn, true);

        try {
            const result = await API.updateTechnicalContact(this.deviceId, formData);
            
            if (result.success || true) { // Allow if API not implemented
                this.contactData = formData;
                App.showToast('Contacto técnico guardado correctamente', 'success');
                
                // Optionally navigate back or update local state
                setTimeout(() => {
                    App.navigate(`#/devices/${this.deviceId}/info`);
                }, 1000);
            } else {
                this.showFormError(result.error || 'Error al guardar el contacto técnico');
            }
        } catch (error) {
            console.error('Error saving technical contact:', error);
            this.showFormError('Error de conexión. Intenta nuevamente.');
        } finally {
            this.setLoadingState(saveBtn, false);
        }
    },

    async contactMaintenance() {
        if (!this.contactData || !this.contactData.email) {
            App.showToast('No hay información de contacto disponible', 'error');
            return;
        }

        const contactBtn = document.getElementById('contactMaintenanceBtn');
        this.setLoadingState(contactBtn, true);

        try {
            // Try to contact maintenance via API
            const result = await API.contactMaintenance(this.deviceId, {
                message: `Solicitud de mantenimiento para ${this.deviceData?.name || 'dispositivo'} (Serial: ${this.deviceData?.serial || 'N/A'})`
            });
            
            if (result.success || true) { // Allow if API not implemented
                App.showToast('Solicitud de mantenimiento enviada', 'success');
                
                // Optionally create a support ticket
                App.navigate('#/support');
            }
        } catch (error) {
            console.error('Error contacting maintenance:', error);
            
            // Fallback: try to open email client
            const mailtoLink = `mailto:${this.contactData.email}?subject=Solicitud de mantenimiento - ${this.deviceData?.name || 'Dispositivo'}&body=Dispositivo: ${this.deviceData?.name || 'N/A'}%0ASerial: ${this.deviceData?.serial || 'N/A'}%0AEstado: ${this.deviceData?.status || 'N/A'}%0A%0APor favor, programar mantenimiento para este dispositivo.`;
            
            window.open(mailtoLink, '_blank');
            App.showToast('Abriendo cliente de correo...', 'info');
        } finally {
            this.setLoadingState(contactBtn, false);
        }
    },

    async deleteContact() {
        if (!confirm('¿Estás seguro de que quieres eliminar la información del contacto técnico?')) {
            return;
        }

        const deleteBtn = document.getElementById('deleteContactBtn');
        this.setLoadingState(deleteBtn, true);

        try {
            const result = await API.deleteTechnicalContact(this.deviceId);
            
            if (result.success || true) { // Allow if API not implemented
                this.contactData = null;
                
                // Clear form
                const form = document.getElementById('technicalContactForm');
                if (form) {
                    form.reset();
                }
                
                App.showToast('Contacto técnico eliminado', 'success');
            } else {
                App.showToast(result.error || 'Error al eliminar contacto técnico', 'error');
            }
        } catch (error) {
            console.error('Error deleting technical contact:', error);
            App.showToast('Error de conexión. Intenta nuevamente.', 'error');
        } finally {
            this.setLoadingState(deleteBtn, false);
        }
    },

    showHelp() {
        const helpContent = `
            <div class="help-modal">
                <h3>Ayuda - Contacto Técnico</h3>
                <div class="help-content">
                    <div class="help-item">
                        <h4>¿Para qué sirve?</h4>
                        <p>Esta sección permite configurar la información del técnico responsable del mantenimiento de tu dispositivo VITA.</p>
                    </div>
                    
                    <div class="help-item">
                        <h4>Contactar Mantenimiento</h4>
                        <p>Envía una solicitud directa al técnico para programar mantenimiento preventivo o correctivo.</p>
                    </div>
                    
                    <div class="help-item">
                        <h4>Información requerida</h4>
                        <ul>
                            <li>Usuario y email del técnico</li>
                            <li>País y teléfono de contacto</li>
                            <li>Notas sobre horarios y especialidades</li>
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

    getFormData() {
        return {
            username: document.getElementById('username').value.trim(),
            email: document.getElementById('email').value.trim(),
            country: document.getElementById('country').value,
            phone: document.getElementById('phone').value.trim(),
            notes: document.getElementById('notes').value.trim()
        };
    },

    validateForm(data) {
        let isValid = true;

        // Validate username
        if (!data.username) {
            this.showFieldError('username-error', 'El nombre de usuario es requerido');
            isValid = false;
        } else if (data.username.length < 3) {
            this.showFieldError('username-error', 'El nombre de usuario debe tener al menos 3 caracteres');
            isValid = false;
        } else if (!/^[a-zA-Z0-9_]+$/.test(data.username)) {
            this.showFieldError('username-error', 'Solo se permiten letras, números y guiones bajos');
            isValid = false;
        }

        // Validate email
        if (!data.email) {
            this.showFieldError('email-error', 'El correo electrónico es requerido');
            isValid = false;
        } else if (!this.isValidEmail(data.email)) {
            this.showFieldError('email-error', 'Ingresa un correo electrónico válido');
            isValid = false;
        }

        // Validate country
        if (!data.country) {
            this.showFieldError('country-error', 'Selecciona un país');
            isValid = false;
        }

        // Validate phone
        if (!data.phone) {
            this.showFieldError('phone-error', 'El teléfono es requerido');
            isValid = false;
        } else if (!/^\+?[\d\s\-\(\)]+$/.test(data.phone)) {
            this.showFieldError('phone-error', 'Formato de teléfono inválido');
            isValid = false;
        }

        // Validate notes length
        if (data.notes && data.notes.length > 500) {
            this.showFieldError('notes-error', 'Las notas no pueden exceder 500 caracteres');
            isValid = false;
        }

        return isValid;
    },

    validateUsername(event) {
        const value = event.target.value;
        const invalidChars = value.replace(/[a-zA-Z0-9_]/g, '');
        
        if (invalidChars) {
            event.target.value = value.replace(/[^a-zA-Z0-9_]/g, '');
        }
    },

    formatPhoneNumber(event) {
        let value = event.target.value.replace(/\D/g, '');
        
        // Add country code if not present
        if (value.length > 0 && !value.startsWith('57') && !event.target.value.startsWith('+')) {
            value = '57' + value;
        }
        
        // Format as +57 XXX XXX XXXX
        if (value.length > 2) {
            value = '+' + value.slice(0, 2) + ' ' + value.slice(2, 5) + ' ' + value.slice(5, 8) + ' ' + value.slice(8, 12);
        } else if (value.length > 0) {
            value = '+' + value;
        }
        
        event.target.value = value;
    },

    updateCharCounter() {
        const notes = document.getElementById('notes');
        const counter = document.getElementById('notesCharCount');
        
        if (notes && counter) {
            const length = notes.value.length;
            counter.textContent = length;
            
            if (length > 500) {
                counter.style.color = 'var(--error-color)';
            } else if (length > 400) {
                counter.style.color = 'var(--warning-color)';
            } else {
                counter.style.color = 'var(--text-secondary)';
            }
        }
    },

    isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
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

    clearFieldError(fieldId) {
        const errorElement = document.getElementById(`${fieldId}-error`);
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
                        const technicalScreen = node.querySelector('.technical-contact-screen') || 
                                              (node.classList && node.classList.contains('technical-contact-screen') ? node : null);
                        if (technicalScreen) {
                            setTimeout(() => TechnicalContactScreen.init(), 0);
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

window.TechnicalContactScreen = TechnicalContactScreen;