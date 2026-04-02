// Reset Password Screen Module
const ResetPasswordScreen = {
    currentStep: 1, // 1: email, 2: code + new password
    countdown: 0,
    countdownInterval: null,

    render() {
        return `
            <div class="reset-password-container">
                <div class="header">
                    <button class="header-back material-icons" onclick="App.goBack()">
                        arrow_back
                    </button>
                    <h1 class="header-title" style="color: var(--title-blue); font-family: 'Montserrat', sans-serif;">Restablecer Contraseña</h1>
                </div>
                
                <div class="form-container">
                    ${this.renderCurrentStep()}
                </div>
            </div>
        `;
    },

    renderCurrentStep() {
        if (this.currentStep === 1) {
            return this.renderEmailStep();
        } else {
            return this.renderCodeStep();
        }
    },

    renderEmailStep() {
        return `
            <div class="reset-step" id="emailStep">
                <div class="step-header" style="text-align: center; margin-bottom: 32px;">
                    <span class="material-icons" style="font-size: 64px; color: var(--primary-purple); margin-bottom: 16px;">lock_reset</span>
                    <h2 style="color: var(--text-primary); margin-bottom: 8px;">¿Olvidaste tu contraseña?</h2>
                    <p style="color: var(--text-secondary);">Ingresa tu correo electrónico y te enviaremos un código para restablecer tu contraseña.</p>
                </div>
                
                <form class="reset-form" id="emailForm">
                    <div class="form-field">
                        <label for="resetEmail" class="form-label">Correo Electrónico</label>
                        <input 
                            type="email" 
                            id="resetEmail" 
                            class="form-input" 
                            required 
                            placeholder="ejemplo@correo.com"
                            autocomplete="email"
                        >
                        <div id="resetEmail-error" class="form-error hidden"></div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary" id="sendCodeButton" style="margin-top: 24px;">
                        <span class="material-icons">send</span>
                        Obtener código temporal
                    </button>
                    
                    <div id="email-error" class="form-error hidden mt-16"></div>
                    
                    <div class="text-center" style="margin-top: 24px;">
                        <a href="#/login" style="color: var(--primary-purple); text-decoration: none; font-size: 14px;">Volver al inicio de sesión</a>
                    </div>
                </form>
            </div>
        `;
    },

    renderCodeStep() {
        return `
            <div class="reset-step" id="codeStep">
                <div class="step-header" style="text-align: center; margin-bottom: 32px;">
                    <span class="material-icons" style="font-size: 64px; color: var(--success-color); margin-bottom: 16px;">mark_email_read</span>
                    <h2 style="color: var(--text-primary); margin-bottom: 8px;">Código enviado</h2>
                    <p style="color: var(--text-secondary); margin-bottom: 16px;">Hemos enviado un código de verificación a tu correo electrónico.</p>
                    
                    <div class="countdown-timer" id="countdownTimer" style="display: ${this.countdown > 0 ? 'flex' : 'none'}; align-items: center; justify-content: center; gap: 8px; color: var(--warning-color); font-weight: 600;">
                        <span class="material-icons">schedule</span>
                        <span id="countdownText">00:${String(this.countdown).padStart(2, '0')}</span>
                    </div>
                    
                    <button 
                        class="btn btn-secondary" 
                        id="resendCodeButton" 
                        onclick="ResetPasswordScreen.resendCode()"
                        style="margin-top: 16px; ${this.countdown > 0 ? 'display: none;' : ''}"
                    >
                        <span class="material-icons">refresh</span>
                        Reenviar código
                    </button>
                </div>
                
                <form class="reset-form" id="codeForm">
                    <div class="form-field">
                        <label for="verificationCode" class="form-label">Código de verificación</label>
                        <input 
                            type="text" 
                            id="verificationCode" 
                            class="form-input" 
                            required 
                            placeholder="123456"
                            maxlength="6"
                            style="text-align: center; font-size: 18px; font-weight: 600; letter-spacing: 4px;"
                        >
                        <div id="verificationCode-error" class="form-error hidden"></div>
                    </div>
                    
                    <div class="form-field">
                        <label for="newPassword" class="form-label">Nueva Contraseña</label>
                        <input 
                            type="password" 
                            id="newPassword" 
                            class="form-input" 
                            required 
                            placeholder="Mínimo 8 caracteres"
                        >
                        <div id="newPassword-error" class="form-error hidden"></div>
                    </div>
                    
                    <div class="form-field">
                        <label for="confirmNewPassword" class="form-label">Confirmar Nueva Contraseña</label>
                        <input 
                            type="password" 
                            id="confirmNewPassword" 
                            class="form-input" 
                            required 
                            placeholder="Repite la nueva contraseña"
                        >
                        <div id="confirmNewPassword-error" class="form-error hidden"></div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary" id="resetPasswordButton" style="margin-top: 24px;">
                        <span class="material-icons">lock</span>
                        Cambiar Contraseña
                    </button>
                    
                    <div id="reset-error" class="form-error hidden mt-16"></div>
                </form>
            </div>
        `;
    },

    // Initialize reset password screen events after render
    init() {
        if (this.currentStep === 1) {
            this.initEmailStep();
        } else {
            this.initCodeStep();
        }
    },

    initEmailStep() {
        const form = document.getElementById('emailForm');
        if (!form) return;

        // Handle form submission
        form.addEventListener('submit', async (e) => {
            e.preventDefault();
            await this.handleSendCode();
        });

        // Clear errors on input
        const emailInput = document.getElementById('resetEmail');
        emailInput.addEventListener('input', () => this.clearError('resetEmail-error'));

        // Focus email field
        emailInput.focus();
    },

    initCodeStep() {
        const form = document.getElementById('codeForm');
        if (!form) return;

        // Handle form submission
        form.addEventListener('submit', async (e) => {
            e.preventDefault();
            await this.handleResetPassword();
        });

        // Clear errors on input
        const inputs = form.querySelectorAll('input');
        inputs.forEach(input => {
            input.addEventListener('input', () => this.clearError(`${input.id}-error`));
        });

        // Auto-format verification code
        const codeInput = document.getElementById('verificationCode');
        codeInput.addEventListener('input', (e) => {
            e.target.value = e.target.value.replace(/\D/g, '').slice(0, 6);
        });

        // Focus code field
        codeInput.focus();

        // Start countdown if needed
        if (this.countdown > 0) {
            this.startCountdown();
        }
    },

    async handleSendCode() {
        const email = document.getElementById('resetEmail').value.trim();
        const button = document.getElementById('sendCodeButton');

        // Clear previous errors
        this.clearAllErrors();

        // Validate email
        if (!email) {
            this.showError('resetEmail-error', 'El correo electrónico es requerido');
            return;
        }

        if (!this.isValidEmail(email)) {
            this.showError('resetEmail-error', 'Ingresa un correo electrónico válido');
            return;
        }

        // Show loading state
        this.setLoadingState(button, true, 'Enviando código...');

        try {
            // Mock API call - in real implementation: await API.requestPasswordReset(email)
            await new Promise(resolve => setTimeout(resolve, 1500));
            
            // Move to step 2
            this.currentStep = 2;
            this.countdown = 60; // 60 second countdown
            
            // Re-render with new step
            const container = document.querySelector('.form-container');
            container.innerHTML = this.renderCurrentStep();
            this.initCodeStep();
            
            App.showToast('Código enviado a tu correo electrónico', 'success');
            
        } catch (error) {
            console.error('Send code error:', error);
            this.showError('email-error', 'Error enviando código. Intenta nuevamente.');
        } finally {
            this.setLoadingState(button, false);
        }
    },

    async handleResetPassword() {
        const code = document.getElementById('verificationCode').value.trim();
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmNewPassword').value;
        const button = document.getElementById('resetPasswordButton');

        // Clear previous errors
        this.clearAllErrors();

        // Validate inputs
        if (!this.validateResetForm(code, newPassword, confirmPassword)) {
            return;
        }

        // Show loading state
        this.setLoadingState(button, true, 'Cambiando contraseña...');

        try {
            // Mock API call - in real implementation: await API.resetPassword(code, newPassword)
            await new Promise(resolve => setTimeout(resolve, 1500));
            
            App.showToast('Contraseña cambiada exitosamente', 'success');
            App.navigate('#/login');
            
        } catch (error) {
            console.error('Reset password error:', error);
            this.showError('reset-error', 'Código inválido o expirado. Intenta nuevamente.');
        } finally {
            this.setLoadingState(button, false);
        }
    },

    async resendCode() {
        const button = document.getElementById('resendCodeButton');
        this.setLoadingState(button, true, 'Reenviando...');

        try {
            // Mock API call
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            this.countdown = 60;
            this.startCountdown();
            
            App.showToast('Código reenviado', 'success');
            
        } catch (error) {
            App.showToast('Error reenviando código', 'error');
        } finally {
            this.setLoadingState(button, false);
        }
    },

    validateResetForm(code, newPassword, confirmPassword) {
        let isValid = true;

        if (!code || code.length !== 6) {
            this.showError('verificationCode-error', 'Ingresa el código de 6 dígitos');
            isValid = false;
        }

        if (!newPassword) {
            this.showError('newPassword-error', 'La nueva contraseña es requerida');
            isValid = false;
        } else if (newPassword.length < 8) {
            this.showError('newPassword-error', 'La contraseña debe tener al menos 8 caracteres');
            isValid = false;
        }

        if (!confirmPassword) {
            this.showError('confirmNewPassword-error', 'Confirma la nueva contraseña');
            isValid = false;
        } else if (newPassword !== confirmPassword) {
            this.showError('confirmNewPassword-error', 'Las contraseñas no coinciden');
            isValid = false;
        }

        return isValid;
    },

    startCountdown() {
        const timerElement = document.getElementById('countdownTimer');
        const textElement = document.getElementById('countdownText');
        const resendButton = document.getElementById('resendCodeButton');

        if (timerElement) timerElement.style.display = 'flex';
        if (resendButton) resendButton.style.display = 'none';

        this.countdownInterval = setInterval(() => {
            this.countdown--;
            if (textElement) {
                const minutes = Math.floor(this.countdown / 60);
                const seconds = this.countdown % 60;
                textElement.textContent = `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
            }

            if (this.countdown <= 0) {
                clearInterval(this.countdownInterval);
                if (timerElement) timerElement.style.display = 'none';
                if (resendButton) resendButton.style.display = 'inline-flex';
            }
        }, 1000);
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
            if (button.id === 'sendCodeButton') {
                button.innerHTML = `
                    <span class="material-icons">send</span>
                    Obtener código temporal
                `;
            } else if (button.id === 'resetPasswordButton') {
                button.innerHTML = `
                    <span class="material-icons">lock</span>
                    Cambiar Contraseña
                `;
            } else if (button.id === 'resendCodeButton') {
                button.innerHTML = `
                    <span class="material-icons">refresh</span>
                    Reenviar código
                `;
            }
        }
    },

    // Cleanup when leaving screen
    destroy() {
        if (this.countdownInterval) {
            clearInterval(this.countdownInterval);
            this.countdownInterval = null;
        }
        this.currentStep = 1;
        this.countdown = 0;
    }
};

// Auto-initialize when content is rendered
document.addEventListener('DOMContentLoaded', () => {
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.addedNodes) {
                mutation.addedNodes.forEach((node) => {
                    if (node.nodeType === Node.ELEMENT_NODE) {
                        const resetContainer = node.querySelector('.reset-password-container') || 
                                             (node.classList && node.classList.contains('reset-password-container') ? node : null);
                        if (resetContainer) {
                            setTimeout(() => ResetPasswordScreen.init(), 0);
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

window.ResetPasswordScreen = ResetPasswordScreen;