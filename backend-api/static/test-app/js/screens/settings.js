// Settings/Profile Screen Module
const SettingsScreen = {
    currentUser: null,

    async render() {
        try {
            App.showLoading();

            // In real implementation, this would fetch user profile
            this.currentUser = this.getMockUserProfile();

            App.hideLoading();

            return `
                <div class="settings-container">
                    ${this.renderHeader()}
                    ${this.renderUserProfile()}
                    ${this.renderSettingsSections()}
                    ${this.renderLogoutSection()}
                </div>
            `;
        } catch (error) {
            console.error('Error rendering settings screen:', error);
            App.hideLoading();
            return this.renderError('Error cargando configuración');
        }
    },

    renderHeader() {
        return `
            <div class="header">
                <button class="header-back material-icons" onclick="App.goBack()">
                    arrow_back
                </button>
                <h1 class="header-title" style="color: var(--title-blue); font-family: 'Montserrat', sans-serif;">Configuración</h1>
            </div>
        `;
    },

    renderUserProfile() {
        return `
            <div class="user-profile-section" style="margin: 16px; padding: 24px; background: linear-gradient(135deg, var(--primary-purple), var(--accent-purple)); border-radius: 12px; color: white;">
                <div style="display: flex; align-items: center; gap: 20px;">
                    <div class="profile-avatar" style="width: 80px; height: 80px; border-radius: 50%; background-color: rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center; font-size: 32px; font-weight: 700; border: 3px solid rgba(255,255,255,0.3);">
                        ${this.currentUser.name ? this.currentUser.name.charAt(0).toUpperCase() : 'U'}
                    </div>
                    
                    <div style="flex: 1;">
                        <h2 style="margin: 0 0 8px 0; font-family: 'Montserrat', sans-serif; font-weight: 700;">${this.currentUser.name || 'Usuario'}</h2>
                        <p style="margin: 0 0 4px 0; opacity: 0.9; font-size: 16px;">${this.currentUser.email || 'Sin email'}</p>
                        <p style="margin: 0; opacity: 0.7; font-size: 14px;">${this.currentUser.role || 'Usuario'} • ${this.currentUser.company || 'BGnius'}</p>
                    </div>
                    
                    <button class="btn" onclick="SettingsScreen.editProfile()" style="background-color: rgba(255,255,255,0.2); border: 1px solid rgba(255,255,255,0.3); color: white;">
                        <span class="material-icons">edit</span>
                    </button>
                </div>
                
                <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.2); display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; text-align: center;">
                    <div>
                        <div style="font-size: 24px; font-weight: 700;">${this.currentUser.devices_count || 0}</div>
                        <div style="font-size: 12px; opacity: 0.8;">Dispositivos</div>
                    </div>
                    <div>
                        <div style="font-size: 24px; font-weight: 700;">${this.currentUser.groups_count || 0}</div>
                        <div style="font-size: 12px; opacity: 0.8;">Grupos</div>
                    </div>
                    <div>
                        <div style="font-size: 24px; font-weight: 700;">${this.currentUser.days_active || 0}</div>
                        <div style="font-size: 12px; opacity: 0.8;">Días Activo</div>
                    </div>
                </div>
            </div>
        `;
    },

    renderSettingsSections() {
        return `
            <div class="settings-sections" style="margin: 16px;">
                
                <!-- Account Settings -->
                <div class="settings-section">
                    <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px; font-family: 'Montserrat', sans-serif;">
                        <span class="material-icons" style="vertical-align: middle; margin-right: 8px;">person</span>
                        Cuenta
                    </h3>
                    
                    <div class="settings-items">
                        ${this.renderSettingItem('edit', 'Editar Perfil', 'Cambiar nombre, email y datos personales', () => 'SettingsScreen.editProfile()')}
                        ${this.renderSettingItem('lock', 'Cambiar Contraseña', 'Actualizar contraseña de seguridad', () => 'SettingsScreen.changePassword()')}
                        ${this.renderSettingItem('security', 'Autenticación de Dos Factores', 'Habilitar 2FA para mayor seguridad', () => 'SettingsScreen.setup2FA()')}
                        ${this.renderSettingItem('verified_user', 'Verificación de Cuenta', 'Estado de verificación de email y teléfono', () => 'SettingsScreen.accountVerification()')}
                    </div>
                </div>

                <!-- Device Settings -->
                <div class="settings-section" style="margin-top: 32px;">
                    <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px; font-family: 'Montserrat', sans-serif;">
                        <span class="material-icons" style="vertical-align: middle; margin-right: 8px;">devices</span>
                        Dispositivos
                    </h3>
                    
                    <div class="settings-items">
                        ${this.renderSettingItem('add_circle', 'Agregar Dispositivo', 'Configurar nuevo dispositivo VITA', () => 'SettingsScreen.addDevice()')}
                        ${this.renderSettingItem('group_work', 'Gestionar Grupos', 'Organizar dispositivos en grupos', () => 'SettingsScreen.manageGroups()')}
                        ${this.renderSettingItem('share', 'Usuarios Compartidos', 'Gestionar accesos de usuarios', () => 'SettingsScreen.manageSharedUsers()')}
                        ${this.renderSettingItem('backup', 'Respaldo de Configuración', 'Exportar/importar configuraciones', () => 'SettingsScreen.backupSettings()')}
                    </div>
                </div>

                <!-- App Settings -->
                <div class="settings-section" style="margin-top: 32px;">
                    <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px; font-family: 'Montserrat', sans-serif;">
                        <span class="material-icons" style="vertical-align: middle; margin-right: 8px;">settings</span>
                        Aplicación
                    </h3>
                    
                    <div class="settings-items">
                        ${this.renderSettingToggle('notifications', 'Notificaciones Push', 'Recibir alertas de dispositivos', true)}
                        ${this.renderSettingToggle('vibration', 'Vibración', 'Vibrar con notificaciones', true)}
                        ${this.renderSettingToggle('dark_mode', 'Modo Oscuro', 'Tema visual de la aplicación', false)}
                        ${this.renderSettingItem('language', 'Idioma', 'Español (Colombia)', () => 'SettingsScreen.changeLanguage()')}
                        ${this.renderSettingItem('schedule', 'Zona Horaria', 'GMT-5 (Bogotá)', () => 'SettingsScreen.changeTimezone()')}
                    </div>
                </div>

                <!-- Support -->
                <div class="settings-section" style="margin-top: 32px;">
                    <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px; font-family: 'Montserrat', sans-serif;">
                        <span class="material-icons" style="vertical-align: middle; margin-right: 8px;">help</span>
                        Soporte y Legal
                    </h3>
                    
                    <div class="settings-items">
                        ${this.renderSettingItem('help_center', 'Centro de Ayuda', 'Preguntas frecuentes y tutoriales', () => 'SettingsScreen.openHelpCenter()')}
                        ${this.renderSettingItem('support_agent', 'Contactar Soporte', 'Hablar con el equipo de BGnius', () => 'SettingsScreen.contactSupport()')}
                        ${this.renderSettingItem('bug_report', 'Reportar Problema', 'Informar errores o sugerencias', () => 'SettingsScreen.reportBug()')}
                        ${this.renderSettingItem('policy', 'Términos y Condiciones', 'Políticas de uso y privacidad', () => 'SettingsScreen.viewTerms()')}
                        ${this.renderSettingItem('info', 'Acerca de', 'Versión de la app e información', () => 'SettingsScreen.showAbout()')}
                    </div>
                </div>
            </div>
        `;
    },

    renderSettingItem(icon, title, description, onclick) {
        return `
            <div class="setting-item" onclick="${onclick()}" style="display: flex; align-items: center; gap: 16px; padding: 16px; background-color: var(--surface-color); border-radius: 8px; margin-bottom: 8px; cursor: pointer; transition: all 0.2s; border: 1px solid var(--divider-color);">
                <span class="material-icons" style="color: var(--primary-purple); font-size: 24px;">${icon}</span>
                <div style="flex: 1;">
                    <div style="font-weight: 600; color: var(--text-primary);">${title}</div>
                    <div style="font-size: 14px; color: var(--text-secondary); margin-top: 2px;">${description}</div>
                </div>
                <span class="material-icons" style="color: var(--text-hint);">chevron_right</span>
            </div>
        `;
    },

    renderSettingToggle(id, title, description, defaultValue) {
        return `
            <div class="setting-item" style="display: flex; align-items: center; gap: 16px; padding: 16px; background-color: var(--surface-color); border-radius: 8px; margin-bottom: 8px; border: 1px solid var(--divider-color);">
                <span class="material-icons" style="color: var(--primary-purple); font-size: 24px;">
                    ${id === 'notifications' ? 'notifications' : id === 'vibration' ? 'vibration' : 'dark_mode'}
                </span>
                <div style="flex: 1;">
                    <div style="font-weight: 600; color: var(--text-primary);">${title}</div>
                    <div style="font-size: 14px; color: var(--text-secondary); margin-top: 2px;">${description}</div>
                </div>
                <label class="toggle-switch">
                    <input type="checkbox" id="${id}_toggle" ${defaultValue ? 'checked' : ''} onchange="SettingsScreen.toggleSetting('${id}', this.checked)">
                    <span class="toggle-slider"></span>
                </label>
            </div>
        `;
    },

    renderLogoutSection() {
        return `
            <div class="logout-section" style="margin: 32px 16px 16px;">
                <button class="btn" onclick="SettingsScreen.logout()" style="width: 100%; background-color: var(--error-color); color: white; padding: 16px; font-size: 16px; font-weight: 600;">
                    <span class="material-icons">logout</span>
                    Cerrar Sesión
                </button>
                
                <div style="text-align: center; margin-top: 24px; padding: 16px; color: var(--text-hint); font-size: 12px;">
                    <p style="margin: 0 0 8px 0;">VITA por BGnius</p>
                    <p style="margin: 0;">Versión 1.0.0 (Build 100)</p>
                </div>
            </div>
        `;
    },

    renderError(errorMessage) {
        return `
            <div class="settings-container">
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
                        <button class="btn btn-primary" onclick="App.navigate('#/devices')">
                            <span class="material-icons">arrow_back</span>
                            Volver a Dispositivos
                        </button>
                    </div>
                </div>
            </div>
        `;
    },

    getMockUserProfile() {
        return {
            id: '1',
            name: 'Administrator',
            email: 'admin@bgnius.com',
            role: 'Administrador',
            company: 'BGnius VITA',
            devices_count: 3,
            groups_count: 2,
            days_active: 45,
            created_at: '2024-01-15T00:00:00Z',
            verified_email: true,
            verified_phone: false,
            two_factor_enabled: false
        };
    },

    // Initialize settings screen
    init() {
        // Add hover effects for setting items
        const settingItems = document.querySelectorAll('.setting-item[onclick]');
        settingItems.forEach(item => {
            item.addEventListener('mouseenter', () => {
                item.style.backgroundColor = 'rgba(123, 44, 191, 0.04)';
                item.style.transform = 'translateY(-1px)';
                item.style.boxShadow = '0 2px 8px rgba(0,0,0,0.1)';
            });
            
            item.addEventListener('mouseleave', () => {
                item.style.backgroundColor = 'var(--surface-color)';
                item.style.transform = 'translateY(0)';
                item.style.boxShadow = 'none';
            });
        });
    },

    // Setting action methods
    editProfile() {
        App.navigate('#/profile/edit');
    },

    changePassword() {
        App.navigate('#/profile/change-password');
    },

    setup2FA() {
        App.showToast('Funcionalidad próximamente disponible', 'info');
    },

    accountVerification() {
        App.showToast('Funcionalidad próximamente disponible', 'info');
    },

    addDevice() {
        App.navigate('#/add-device');
    },

    manageGroups() {
        App.navigate('#/groups');
    },

    manageSharedUsers() {
        App.showToast('Funcionalidad próximamente disponible', 'info');
    },

    backupSettings() {
        App.showToast('Funcionalidad próximamente disponible', 'info');
    },

    changeLanguage() {
        const languages = ['Español (Colombia)', 'Español (México)', 'English (US)', 'Português (Brasil)'];
        const selected = prompt(`Selecciona idioma:\n\n${languages.map((l, i) => `${i + 1}. ${l}`).join('\n')}\n\nEscribe el número:`);
        
        if (selected && selected >= 1 && selected <= languages.length) {
            App.showToast(`Idioma cambiado a: ${languages[selected - 1]}`, 'success');
        }
    },

    changeTimezone() {
        const timezones = ['GMT-5 (Bogotá)', 'GMT-6 (México DF)', 'GMT-5 (Nueva York)', 'GMT-3 (São Paulo)'];
        const selected = prompt(`Selecciona zona horaria:\n\n${timezones.map((t, i) => `${i + 1}. ${t}`).join('\n')}\n\nEscribe el número:`);
        
        if (selected && selected >= 1 && selected <= timezones.length) {
            App.showToast(`Zona horaria cambiada a: ${timezones[selected - 1]}`, 'success');
        }
    },

    openHelpCenter() {
        App.showToast('Funcionalidad próximamente disponible', 'info');
    },

    contactSupport() {
        App.navigate('#/support');
    },

    reportBug() {
        App.navigate('#/support/report');
    },

    viewTerms() {
        App.showToast('Funcionalidad próximamente disponible', 'info');
    },

    showAbout() {
        alert(`VITA - Control de Accesos BGnius
        
Versión: 1.0.0
Build: 100
Desarrollado por: BGnius
        
© 2024 BGnius. Todos los derechos reservados.`);
    },

    toggleSetting(settingId, value) {
        const settingNames = {
            'notifications': 'Notificaciones',
            'vibration': 'Vibración',
            'dark_mode': 'Modo Oscuro'
        };
        
        const settingName = settingNames[settingId] || settingId;
        App.showToast(`${settingName} ${value ? 'activado' : 'desactivado'}`, 'success');
        
        // Store setting preference (in real app, this would sync to server)
        localStorage.setItem(`setting_${settingId}`, value.toString());
    },

    logout() {
        if (confirm('¿Estás seguro de que quieres cerrar sesión?')) {
            App.logout();
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
                        const settingsContainer = node.querySelector('.settings-container') || 
                                                (node.classList && node.classList.contains('settings-container') ? node : null);
                        if (settingsContainer) {
                            setTimeout(() => SettingsScreen.init(), 0);
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

window.SettingsScreen = SettingsScreen;