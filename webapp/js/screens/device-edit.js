// Device Edit Screen Module
const DeviceEditScreen = {
    currentDevice: null,
    groups: [],

    async render(deviceId) {
        if (!deviceId) {
            return this.renderError('ID de dispositivo no proporcionado');
        }

        try {
            App.showLoading();

            // Fetch device details and groups
            const [deviceResult, groupsResult] = await Promise.all([
                API.getDeviceDetail(deviceId),
                API.getGroups()
            ]);

            App.hideLoading();

            if (!deviceResult.success) {
                return this.renderError(deviceResult.error || 'Error cargando dispositivo');
            }

            this.currentDevice = deviceResult.data;
            this.groups = groupsResult.success ? (groupsResult.data?.data || []) : [];

            return `
                <div class="device-edit-container">
                    ${this.renderHeader()}
                    ${this.renderDeviceInfoBanner()}
                    ${this.renderEditForm()}
                </div>
            `;
        } catch (error) {
            console.error('Error rendering device edit:', error);
            App.hideLoading();
            return this.renderError('Error cargando editor de dispositivo');
        }
    },

    renderHeader() {
        return `
            <div class="header">
                <button class="header-back material-icons" onclick="App.goBack()">
                    arrow_back
                </button>
                <h1 class="header-title" style="color: var(--title-blue); font-family: 'Montserrat', sans-serif;">Editar Dispositivo</h1>
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

    renderEditForm() {
        const device = this.currentDevice;
        if (!device) return '';

        return `
            <div class="form-container">
                <form class="device-edit-form" id="deviceEditForm">
                    <!-- Device Photo Section -->
                    <div class="form-section">
                        <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px;">Foto del Dispositivo</h3>
                        <div class="photo-upload-container" style="text-align: center; margin-bottom: 24px;">
                            <div class="photo-preview" style="width: 120px; height: 120px; border-radius: 8px; background-color: #f0f0f0; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px; border: 2px dashed var(--divider-color);">
                                <span class="material-icons" style="font-size: 48px; color: var(--text-hint);">add_a_photo</span>
                            </div>
                            <button type="button" class="btn btn-secondary" id="uploadPhotoBtn">
                                <span class="material-icons">camera_alt</span>
                                Subir Foto
                            </button>
                            <input type="file" id="photoInput" accept="image/*" style="display: none;">
                        </div>
                    </div>

                    <!-- Basic Information -->
                    <div class="form-section">
                        <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px;">Información Básica</h3>
                        
                        <div class="form-field">
                            <label for="deviceName" class="form-label">Nombre del Dispositivo</label>
                            <input 
                                type="text" 
                                id="deviceName" 
                                class="form-input" 
                                value="${device.name || ''}"
                                required 
                                placeholder="Ej: Portón Principal"
                            >
                            <div id="deviceName-error" class="form-error hidden"></div>
                        </div>
                        
                        <div class="form-field">
                            <label for="serialNumber" class="form-label">Número de Serie</label>
                            <input 
                                type="text" 
                                id="serialNumber" 
                                class="form-input" 
                                value="${device.serial_number || ''}"
                                readonly
                                style="background-color: #f8f8f8;"
                            >
                        </div>
                        
                        <div class="form-field">
                            <label for="macAddress" class="form-label">Dirección MAC</label>
                            <input 
                                type="text" 
                                id="macAddress" 
                                class="form-input" 
                                value="${device.mac_address || ''}"
                                readonly
                                style="background-color: #f8f8f8;"
                            >
                        </div>
                        
                        <div class="form-field">
                            <label for="deviceLocation" class="form-label">Ubicación</label>
                            <input 
                                type="text" 
                                id="deviceLocation" 
                                class="form-input" 
                                value="${device.location || ''}"
                                placeholder="Ej: Entrada principal"
                            >
                        </div>
                        
                        <div class="form-field">
                            <label for="deviceGroup" class="form-label">Grupo</label>
                            <select id="deviceGroup" class="form-input">
                                <option value="">Sin grupo</option>
                                ${this.groups.map(group => `
                                    <option value="${group.id}" ${device.group_id === group.id ? 'selected' : ''}>
                                        ${group.name}
                                    </option>
                                `).join('')}
                            </select>
                        </div>
                        
                        <div class="form-field">
                            <label for="activationDate" class="form-label">Fecha de Activación</label>
                            <input 
                                type="date" 
                                id="activationDate" 
                                class="form-input" 
                                value="${device.activation_date ? new Date(device.activation_date).toISOString().split('T')[0] : ''}"
                            >
                        </div>
                    </div>

                    <!-- Status and Preferences -->
                    <div class="form-section">
                        <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px;">Estado y Preferencias</h3>
                        
                        <div class="form-field">
                            <label class="form-label" style="display: flex; align-items: center; justify-content: space-between;">
                                Dispositivo Favorito
                                <label class="toggle-switch">
                                    <input type="checkbox" id="isFavorite" ${device.is_favorite ? 'checked' : ''}>
                                    <span class="toggle-slider"></span>
                                </label>
                            </label>
                        </div>
                        
                        <div class="form-field">
                            <label for="technicianContact" class="form-label">Contacto Técnico</label>
                            <input 
                                type="text" 
                                id="technicianContact" 
                                class="form-input" 
                                value="${device.technician_contact || ''}"
                                placeholder="Nombre del técnico"
                            >
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="form-section">
                        <div style="display: flex; flex-direction: column; gap: 16px;">
                            <button type="button" class="btn btn-secondary" onclick="DeviceEditScreen.viewUsersWithAccess()">
                                <span class="material-icons">people</span>
                                Ver Usuarios con Acceso
                            </button>
                            
                            <button type="button" class="btn btn-secondary" onclick="DeviceEditScreen.viewDeviceInfo()">
                                <span class="material-icons">info</span>
                                Información del Dispositivo
                            </button>
                        </div>
                    </div>

                    <!-- Submit Buttons -->
                    <div class="form-section" style="display: flex; gap: 12px; margin-top: 32px;">
                        <button type="button" class="btn" onclick="App.goBack()" style="flex: 1; background-color: var(--text-hint); color: white;">
                            <span class="material-icons">cancel</span>
                            Cancelar
                        </button>
                        <button type="submit" class="btn btn-primary" id="saveDeviceButton" style="flex: 1;">
                            <span class="material-icons">save</span>
                            Guardar
                        </button>
                    </div>
                    
                    <div id="edit-error" class="form-error hidden mt-16"></div>
                </form>
            </div>
        `;
    },

    renderError(errorMessage) {
        return `
            <div class="device-edit-container">
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

    // Initialize device edit screen events after render
    init() {
        const form = document.getElementById('deviceEditForm');
        if (!form) return;

        // Handle form submission
        form.addEventListener('submit', async (e) => {
            e.preventDefault();
            await this.handleSaveDevice();
        });

        // Handle photo upload
        const uploadBtn = document.getElementById('uploadPhotoBtn');
        const photoInput = document.getElementById('photoInput');
        
        if (uploadBtn && photoInput) {
            uploadBtn.addEventListener('click', () => photoInput.click());
            photoInput.addEventListener('change', (e) => this.handlePhotoUpload(e));
        }

        // Clear errors on input
        const inputs = form.querySelectorAll('input, select');
        inputs.forEach(input => {
            if (input.type !== 'file' && input.type !== 'checkbox') {
                input.addEventListener('input', () => this.clearError(`${input.id}-error`));
            }
        });
    },

    async handleSaveDevice() {
        const formData = this.getFormData();
        const button = document.getElementById('saveDeviceButton');

        // Clear previous errors
        this.clearAllErrors();

        // Validate form
        if (!this.validateForm(formData)) {
            return;
        }

        // Show loading state
        this.setLoadingState(button, true);

        try {
            // Mock API call - in real implementation: await API.updateDevice(this.currentDevice.id, formData)
            await new Promise(resolve => setTimeout(resolve, 1500));
            
            App.showToast('Dispositivo actualizado exitosamente', 'success');
            App.navigate(`#/devices/${this.currentDevice.id}`);
            
        } catch (error) {
            console.error('Save device error:', error);
            this.showError('edit-error', 'Error guardando dispositivo. Intenta nuevamente.');
        } finally {
            this.setLoadingState(button, false);
        }
    },

    async handlePhotoUpload(event) {
        const file = event.target.files[0];
        if (!file) return;

        // Validate file
        if (!file.type.startsWith('image/')) {
            App.showToast('Por favor selecciona una imagen válida', 'error');
            return;
        }

        if (file.size > 5 * 1024 * 1024) { // 5MB
            App.showToast('La imagen debe ser menor a 5MB', 'error');
            return;
        }

        try {
            // Show preview
            const preview = document.querySelector('.photo-preview');
            const reader = new FileReader();
            
            reader.onload = (e) => {
                preview.innerHTML = `<img src="${e.target.result}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 8px;">`;
            };
            
            reader.readAsDataURL(file);

            // Mock upload - in real implementation: await API.uploadDevicePhoto(this.currentDevice.id, file)
            App.showToast('Foto cargada (se guardará al enviar el formulario)', 'success');
            
        } catch (error) {
            console.error('Photo upload error:', error);
            App.showToast('Error cargando foto', 'error');
        }
    },

    getFormData() {
        return {
            name: document.getElementById('deviceName').value.trim(),
            location: document.getElementById('deviceLocation').value.trim(),
            group_id: document.getElementById('deviceGroup').value || null,
            activation_date: document.getElementById('activationDate').value || null,
            is_favorite: document.getElementById('isFavorite').checked,
            technician_contact: document.getElementById('technicianContact').value.trim()
        };
    },

    validateForm(data) {
        let isValid = true;

        if (!data.name) {
            this.showError('deviceName-error', 'El nombre del dispositivo es requerido');
            isValid = false;
        }

        return isValid;
    },

    // Navigation methods
    viewUsersWithAccess() {
        App.navigate(`#/devices/${this.currentDevice.id}/users`);
    },

    viewDeviceInfo() {
        App.navigate(`#/devices/${this.currentDevice.id}/info`);
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
                Guardando...
            `;
        } else {
            button.disabled = false;
            button.innerHTML = `
                <span class="material-icons">save</span>
                Guardar
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
                        const editContainer = node.querySelector('.device-edit-container') || 
                                            (node.classList && node.classList.contains('device-edit-container') ? node : null);
                        if (editContainer) {
                            setTimeout(() => DeviceEditScreen.init(), 0);
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

window.DeviceEditScreen = DeviceEditScreen;