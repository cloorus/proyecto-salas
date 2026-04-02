// Login Screen Module
const LoginScreen = {
    render() {
        return `
            <div class="login-container">
                <div class="login-logo">
                    <h1 style="color: var(--primary-purple); font-family: 'Montserrat', sans-serif; font-weight: 700;">B·gnius</h1>
                    <p style="color: var(--text-secondary); margin-bottom: 8px;">VITA</p>
                    <p style="color: var(--primary-purple); font-weight: 600; margin-bottom: 32px;">Bienvenido</p>
                </div>
                
                <form class="login-form" id="loginForm">
                    <div class="form-field">
                        <label for="email" class="form-label">Correo Electrónico</label>
                        <input 
                            type="email" 
                            id="email" 
                            class="form-input" 
                            value="admin@bgnius.com"
                            required 
                            autocomplete="email"
                        >
                        <div id="email-error" class="form-error hidden"></div>
                    </div>
                    
                    <div class="form-field">
                        <label for="password" class="form-label">Contraseña</label>
                        <input 
                            type="password" 
                            id="password" 
                            class="form-input" 
                            value="Test1234!"
                            required 
                            autocomplete="current-password"
                        >
                        <div id="password-error" class="form-error hidden"></div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary" id="loginButton">
                        <span class="material-icons">login</span>
                        Iniciar Sesión
                    </button>
                    
                    <div id="login-error" class="form-error hidden mt-16"></div>
                    
                    <div class="login-links" style="text-align: center; margin-top: 24px;">
                        <a href="#/reset-password" style="color: var(--error-color); text-decoration: none; font-size: 14px; display: block; margin-bottom: 16px;">¿Olvidó su Contraseña?</a>
                        <a href="#/register" style="color: var(--primary-purple); text-decoration: none; font-size: 14px; font-weight: 500;">Crear Cuenta</a>
                    </div>
                </form>
            </div>
        `;
    },

    // Initialize login screen events after render
    init() {
        const form = document.getElementById('loginForm');
        const button = document.getElementById('loginButton');
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('password');

        if (!form) return;

        // Handle form submission
        form.addEventListener('submit', async (e) => {
            e.preventDefault();
            await this.handleLogin();
        });

        // Clear errors on input
        emailInput.addEventListener('input', () => this.clearError('email-error'));
        passwordInput.addEventListener('input', () => this.clearError('password-error'));

        // Focus first empty field
        if (!emailInput.value) {
            emailInput.focus();
        } else if (!passwordInput.value) {
            passwordInput.focus();
        }
    },

    async handleLogin() {
        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value;
        const button = document.getElementById('loginButton');

        // Clear previous errors
        this.clearAllErrors();

        // Validate inputs
        if (!this.validateForm(email, password)) {
            return;
        }

        // Show loading state
        this.setLoadingState(button, true);

        try {
            const result = await API.login(email, password);

            if (result.success) {
                App.showToast('¡Bienvenido!', 'success');
                App.navigate('#/devices');
            } else {
                this.showError('login-error', result.error || 'Error al iniciar sesión');
            }
        } catch (error) {
            console.error('Login error:', error);
            this.showError('login-error', 'Error de conexión. Intenta nuevamente.');
        } finally {
            this.setLoadingState(button, false);
        }
    },

    validateForm(email, password) {
        let isValid = true;

        // Validate email
        if (!email) {
            this.showError('email-error', 'El correo electrónico es requerido');
            isValid = false;
        } else if (!this.isValidEmail(email)) {
            this.showError('email-error', 'Ingresa un correo electrónico válido');
            isValid = false;
        }

        // Validate password
        if (!password) {
            this.showError('password-error', 'La contraseña es requerida');
            isValid = false;
        } else if (password.length < 6) {
            this.showError('password-error', 'La contraseña debe tener al menos 6 caracteres');
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
        this.clearError('email-error');
        this.clearError('password-error');
        this.clearError('login-error');
    },

    setLoadingState(button, loading) {
        if (!button) return;

        if (loading) {
            button.disabled = true;
            button.innerHTML = `
                <div class="spinner" style="width: 16px; height: 16px; border-width: 2px;"></div>
                Iniciando sesión...
            `;
        } else {
            button.disabled = false;
            button.innerHTML = `
                <span class="material-icons">login</span>
                Iniciar Sesión
            `;
        }
    }
};

// Auto-initialize when content is rendered
document.addEventListener('DOMContentLoaded', () => {
    // Use MutationObserver to detect when login form is added to DOM
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.addedNodes) {
                mutation.addedNodes.forEach((node) => {
                    if (node.nodeType === Node.ELEMENT_NODE) {
                        const loginForm = node.querySelector('#loginForm') || 
                                        (node.id === 'loginForm' ? node : null);
                        if (loginForm) {
                            setTimeout(() => LoginScreen.init(), 0);
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

window.LoginScreen = LoginScreen;