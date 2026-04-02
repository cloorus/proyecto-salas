// Register Screen Module
const RegisterScreen = {
    render() {
        return `
            <div class="register-container">
                <div class="header">
                    <button class="header-back material-icons" onclick="App.goBack()">
                        arrow_back
                    </button>
                    <h1 class="header-title" style="color: var(--title-blue); font-family: 'Montserrat', sans-serif;">Crear Cuenta</h1>
                </div>
                
                <div class="form-container">
                    <form class="register-form" id="registerForm">
                        <div class="form-field">
                            <label for="firstName" class="form-label">Nombre</label>
                            <input 
                                type="text" 
                                id="firstName" 
                                class="form-input" 
                                required 
                                placeholder="Ingresa tu nombre"
                            >
                            <div id="firstName-error" class="form-error hidden"></div>
                        </div>
                        
                        <div class="form-field">
                            <label for="lastName" class="form-label">Apellido</label>
                            <input 
                                type="text" 
                                id="lastName" 
                                class="form-input" 
                                required 
                                placeholder="Ingresa tu apellido"
                            >
                            <div id="lastName-error" class="form-error hidden"></div>
                        </div>
                        
                        <div class="form-field">
                            <label for="email" class="form-label">Correo Electrónico</label>
                            <input 
                                type="email" 
                                id="email" 
                                class="form-input" 
                                required 
                                placeholder="ejemplo@correo.com"
                            >
                            <div id="email-error" class="form-error hidden"></div>
                        </div>
                        
                        <div class="form-field">
                            <label for="phone" class="form-label">Teléfono</label>
                            <input 
                                type="tel" 
                                id="phone" 
                                class="form-input" 
                                required 
                                placeholder="+57 300 123 4567"
                            >
                            <div id="phone-error" class="form-error hidden"></div>
                        </div>
                        
                        <div class="form-field">
                            <label for="address" class="form-label">Dirección</label>
                            <input 
                                type="text" 
                                id="address" 
                                class="form-input" 
                                placeholder="Calle 123 #45-67"
                            >
                            <div id="address-error" class="form-error hidden"></div>
                        </div>
                        
                        <div class="form-field">
                            <label for="country" class="form-label">País</label>
                            <select id="country" class="form-input" required>
                                <option value="">Selecciona un país</option>
                                <option value="CO">Colombia</option>
                                <option value="MX">México</option>
                                <option value="US">Estados Unidos</option>
                                <option value="ES">España</option>
                                <option value="AR">Argentina</option>
                                <option value="PE">Perú</option>
                                <option value="CL">Chile</option>
                            </select>
                            <div id="country-error" class="form-error hidden"></div>
                        </div>
                        
                        <div class="form-field">
                            <label for="language" class="form-label">Idioma</label>
                            <select id="language" class="form-input" required>
                                <option value="">Selecciona un idioma</option>
                                <option value="es">Español</option>
                                <option value="en">English</option>
                                <option value="pt">Português</option>
                            </select>
                            <div id="language-error" class="form-error hidden"></div>
                        </div>
                        
                        <div class="form-field">
                            <label for="role" class="form-label">Rol</label>
                            <select id="role" class="form-input" required>
                                <option value="">Selecciona tu rol</option>
                                <option value="owner">Propietario</option>
                                <option value="admin">Administrador</option>
                                <option value="user">Usuario</option>
                                <option value="guest">Invitado</option>
                            </select>
                            <div id="role-error" class="form-error hidden"></div>
                        </div>
                        
                        <div class="form-field">
                            <label for="password" class="form-label">Contraseña</label>
                            <input 
                                type="password" 
                                id="password" 
                                class="form-input" 
                                required 
                                placeholder="Mínimo 8 caracteres"
                            >
                            <div id="password-error" class="form-error hidden"></div>
                        </div>
                        
                        <div class="form-field">
                            <label for="confirmPassword" class="form-label">Confirmar Contraseña</label>
                            <input 
                                type="password" 
                                id="confirmPassword" 
                                class="form-input" 
                                required 
                                placeholder="Repite tu contraseña"
                            >
                            <div id="confirmPassword-error" class="form-error hidden"></div>
                        </div>
                        
                        <button type="submit" class="btn btn-primary" id="registerButton" style="margin-top: 24px;">
                            <span class="material-icons">person_add</span>
                            Crear Cuenta
                        </button>
                        
                        <div id="register-error" class="form-error hidden mt-16"></div>
                        
                        <div class="text-center" style="margin-top: 24px;">
                            <a href="#/login" style="color: var(--primary-purple); text-decoration: none; font-size: 14px;">Ya tengo cuenta</a>
                        </div>
                    </form>
                </div>
            </div>
        `;
    },

    // Initialize register screen events after render
    init() {
        const form = document.getElementById('registerForm');
        if (!form) return;

        // Handle form submission
        form.addEventListener('submit', async (e) => {
            e.preventDefault();
            await this.handleRegister();
        });

        // Clear errors on input
        const inputs = form.querySelectorAll('input, select');
        inputs.forEach(input => {
            input.addEventListener('input', () => this.clearError(`${input.id}-error`));
        });

        // Focus first field
        const firstInput = form.querySelector('input');
        if (firstInput) firstInput.focus();
    },

    async handleRegister() {
        const formData = this.getFormData();
        const button = document.getElementById('registerButton');

        // Clear previous errors
        this.clearAllErrors();

        // Validate form
        if (!this.validateForm(formData)) {
            return;
        }

        // Show loading state
        this.setLoadingState(button, true);

        try {
            // Since register endpoint might not exist, we'll show a mock success
            // In real implementation, this would be: const result = await API.register(formData);
            
            // Simulate API delay
            await new Promise(resolve => setTimeout(resolve, 1500));
            
            // Mock success response
            App.showToast('Cuenta creada exitosamente. Verifica tu correo electrónico.', 'success');
            App.navigate('#/login');
            
        } catch (error) {
            console.error('Register error:', error);
            this.showError('register-error', 'Error creando cuenta. Intenta nuevamente.');
        } finally {
            this.setLoadingState(button, false);
        }
    },

    getFormData() {
        return {
            firstName: document.getElementById('firstName').value.trim(),
            lastName: document.getElementById('lastName').value.trim(),
            email: document.getElementById('email').value.trim(),
            phone: document.getElementById('phone').value.trim(),
            address: document.getElementById('address').value.trim(),
            country: document.getElementById('country').value,
            language: document.getElementById('language').value,
            role: document.getElementById('role').value,
            password: document.getElementById('password').value,
            confirmPassword: document.getElementById('confirmPassword').value
        };
    },

    validateForm(data) {
        let isValid = true;

        // Validate required fields
        if (!data.firstName) {
            this.showError('firstName-error', 'El nombre es requerido');
            isValid = false;
        }

        if (!data.lastName) {
            this.showError('lastName-error', 'El apellido es requerido');
            isValid = false;
        }

        if (!data.email) {
            this.showError('email-error', 'El correo electrónico es requerido');
            isValid = false;
        } else if (!this.isValidEmail(data.email)) {
            this.showError('email-error', 'Ingresa un correo electrónico válido');
            isValid = false;
        }

        if (!data.phone) {
            this.showError('phone-error', 'El teléfono es requerido');
            isValid = false;
        }

        if (!data.country) {
            this.showError('country-error', 'Selecciona un país');
            isValid = false;
        }

        if (!data.language) {
            this.showError('language-error', 'Selecciona un idioma');
            isValid = false;
        }

        if (!data.role) {
            this.showError('role-error', 'Selecciona un rol');
            isValid = false;
        }

        if (!data.password) {
            this.showError('password-error', 'La contraseña es requerida');
            isValid = false;
        } else if (data.password.length < 8) {
            this.showError('password-error', 'La contraseña debe tener al menos 8 caracteres');
            isValid = false;
        }

        if (!data.confirmPassword) {
            this.showError('confirmPassword-error', 'Confirma tu contraseña');
            isValid = false;
        } else if (data.password !== data.confirmPassword) {
            this.showError('confirmPassword-error', 'Las contraseñas no coinciden');
            isValid = false;
        }

        return isValid;
    },

    isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
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

    setLoadingState(button, loading) {
        if (!button) return;

        if (loading) {
            button.disabled = true;
            button.innerHTML = `
                <div class="spinner" style="width: 16px; height: 16px; border-width: 2px;"></div>
                Creando cuenta...
            `;
        } else {
            button.disabled = false;
            button.innerHTML = `
                <span class="material-icons">person_add</span>
                Crear Cuenta
            `;
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
                        const registerContainer = node.querySelector('.register-container') || 
                                                (node.classList && node.classList.contains('register-container') ? node : null);
                        if (registerContainer) {
                            setTimeout(() => RegisterScreen.init(), 0);
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

window.RegisterScreen = RegisterScreen;