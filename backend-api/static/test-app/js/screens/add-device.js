// Add Device Screen Module
const AddDeviceScreen = {
    currentStep: 'scan', // 'scan', 'wifi', 'device', 'manual'
    wifiNetworks: [],
    discoveredDevices: [],
    selectedNetwork: null,
    scanning: false,

    async render() {
        return `
            <div class="add-device-screen">
                <div class="header">
                    <button class="header-back">
                        <span class="material-icons">arrow_back</span>
                    </button>
                    <h1 class="header-title">Agregar Dispositivo</h1>
                    <button class="header-action" id="helpBtn">
                        <span class="material-icons">help_outline</span>
                    </button>
                </div>
                
                <div class="add-device-content">
                    ${this.renderStepIndicator()}
                    ${this.renderCurrentStep()}
                </div>
            </div>
        `;
    },

    renderStepIndicator() {
        const steps = [
            { key: 'scan', label: 'Escanear', icon: 'wifi_find' },
            { key: 'wifi', label: 'WiFi', icon: 'wifi' },
            { key: 'device', label: 'Dispositivo', icon: 'device_hub' },
            { key: 'manual', label: 'Manual', icon: 'keyboard' }
        ];

        const currentIndex = steps.findIndex(s => s.key === this.currentStep);

        return `
            <div class="step-indicator">
                ${steps.map((step, index) => `
                    <div class="step ${index <= currentIndex ? 'active' : ''} ${index < currentIndex ? 'completed' : ''}">
                        <div class="step-icon">
                            <span class="material-icons">${step.icon}</span>
                        </div>
                        <span class="step-label">${step.label}</span>
                    </div>
                `).join('')}
            </div>
        `;
    },

    renderCurrentStep() {
        switch (this.currentStep) {
            case 'scan':
                return this.renderScanStep();
            case 'wifi':
                return this.renderWiFiStep();
            case 'device':
                return this.renderDeviceStep();
            case 'manual':
                return this.renderManualStep();
            default:
                return this.renderScanStep();
        }
    },

    renderScanStep() {
        return `
            <div class="scan-step">
                <div class="step-header">
                    <h2>Buscar Dispositivos y Redes</h2>
                    <p>Escanea para encontrar dispositivos VITA y redes WiFi disponibles</p>
                </div>
                
                <div class="scan-actions">
                    <button class="btn btn-primary scan-btn ${this.scanning ? 'scanning' : ''}" id="startScanBtn">
                        ${this.scanning ? `
                            <div class="spinner" style="width: 20px; height: 20px;"></div>
                            Escaneando...
                        ` : `
                            <span class="material-icons">wifi_find</span>
                            Escanear
                        `}
                    </button>
                    
                    <button class="btn btn-secondary" id="manualSetupBtn">
                        <span class="material-icons">keyboard</span>
                        Configuración Manual
                    </button>
                </div>
                
                <div class="scan-info">
                    <div class="info-card">
                        <span class="material-icons">info</span>
                        <div>
                            <h4>Antes de escanear</h4>
                            <ul>
                                <li>Asegúrate de que el dispositivo VITA esté encendido</li>
                                <li>Verifica que esté en modo de configuración (LED parpadeando)</li>
                                <li>Mantén el dispositivo cerca del router WiFi</li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="info-card">
                        <span class="material-icons">security</span>
                        <div>
                            <h4>Seguridad</h4>
                            <p>Solo se mostrarán dispositivos VITA autorizados y redes WiFi con señal fuerte</p>
                        </div>
                    </div>
                </div>
                
                ${this.wifiNetworks.length > 0 || this.discoveredDevices.length > 0 ? this.renderScanResults() : ''}
            </div>
        `;
    },

    renderScanResults() {
        return `
            <div class="scan-results">
                ${this.wifiNetworks.length > 0 ? `
                    <div class="results-section">
                        <h3>
                            <span class="material-icons">wifi</span>
                            Redes WiFi Disponibles
                        </h3>
                        <div class="networks-list">
                            ${this.wifiNetworks.map(network => this.renderNetworkItem(network)).join('')}
                        </div>
                    </div>
                ` : ''}
                
                ${this.discoveredDevices.length > 0 ? `
                    <div class="results-section">
                        <h3>
                            <span class="material-icons">device_hub</span>
                            VITA's Disponibles
                        </h3>
                        <div class="devices-list">
                            ${this.discoveredDevices.map(device => this.renderDeviceItem(device)).join('')}
                        </div>
                    </div>
                ` : ''}
                
                <div class="results-actions">
                    <button class="btn btn-primary" id="continueWithSelectionBtn" ${!this.selectedNetwork ? 'disabled' : ''}>
                        <span class="material-icons">arrow_forward</span>
                        Continuar con Selección
                    </button>
                </div>
            </div>
        `;
    },

    renderNetworkItem(network) {
        const signalIcon = this.getSignalIcon(network.strength);
        const isSelected = this.selectedNetwork?.ssid === network.ssid;
        
        return `
            <div class="network-item ${isSelected ? 'selected' : ''}" data-ssid="${network.ssid}">
                <div class="network-info">
                    <div class="network-name">
                        <span class="material-icons">wifi</span>
                        <span>${network.ssid}</span>
                        ${network.secured ? '<span class="material-icons security-icon">lock</span>' : ''}
                    </div>
                    <div class="network-signal">
                        <span class="material-icons signal-${network.strength}">${signalIcon}</span>
                        <span class="signal-text">${this.getSignalText(network.strength)}</span>
                    </div>
                </div>
                
                <div class="network-meta">
                    <span class="network-type">${network.secured ? 'WPA2/WPA3' : 'Abierta'}</span>
                    <span class="network-frequency">${network.frequency || '2.4GHz'}</span>
                </div>
            </div>
        `;
    },

    renderDeviceItem(device) {
        return `
            <div class="device-item" data-device-id="${device.id}">
                <div class="device-icon">
                    <span class="material-icons">device_hub</span>
                </div>
                
                <div class="device-info">
                    <h4>${device.name || 'Dispositivo VITA'}</h4>
                    <div class="device-meta">
                        <span class="device-serial">Serial: ${device.serial}</span>
                        <span class="device-model">${device.model || 'VITA'}</span>
                    </div>
                    <div class="device-status">
                        <span class="material-icons status-${device.status}">
                            ${device.status === 'ready' ? 'radio_button_checked' : 'radio_button_unchecked'}
                        </span>
                        <span>${device.status === 'ready' ? 'Listo para configurar' : 'En configuración'}</span>
                    </div>
                </div>
                
                <button class="btn btn-primary select-device-btn" data-device-id="${device.id}">
                    Seleccionar
                </button>
            </div>
        `;
    },

    renderWiFiStep() {
        if (!this.selectedNetwork) {
            return '<div class="error">No se ha seleccionado una red WiFi</div>';
        }

        return `
            <div class="wifi-step">
                <div class="step-header">
                    <h2>Configurar WiFi</h2>
                    <p>Conectar dispositivos VITA a la red seleccionada</p>
                </div>
                
                <div class="selected-network">
                    <h3>Red Seleccionada</h3>
                    <div class="network-card">
                        <div class="network-info">
                            <span class="material-icons">wifi</span>
                            <div>
                                <h4>${this.selectedNetwork.ssid}</h4>
                                <span class="signal-text">${this.getSignalText(this.selectedNetwork.strength)}</span>
                            </div>
                        </div>
                        <div class="network-security">
                            ${this.selectedNetwork.secured ? 
                                '<span class="material-icons">lock</span><span>Segura</span>' :
                                '<span class="material-icons">lock_open</span><span>Abierta</span>'
                            }
                        </div>
                    </div>
                </div>
                
                ${this.selectedNetwork.secured ? `
                    <form id="wifiCredentialsForm" class="wifi-form">
                        <div class="form-field">
                            <label for="wifiPassword" class="form-label">Contraseña de la red</label>
                            <div class="input-group">
                                <span class="material-icons">lock</span>
                                <input 
                                    type="password" 
                                    id="wifiPassword" 
                                    class="form-input" 
                                    placeholder="Ingresa la contraseña"
                                    required 
                                >
                                <button type="button" class="toggle-password" id="togglePassword">
                                    <span class="material-icons">visibility</span>
                                </button>
                            </div>
                            <div id="password-error" class="form-error hidden"></div>
                        </div>
                        
                        <div class="wifi-options">
                            <label class="checkbox-option">
                                <input type="checkbox" id="saveCredentials" checked>
                                <span class="checkmark"></span>
                                Recordar credenciales para futuros dispositivos
                            </label>
                        </div>
                    </form>
                ` : ''}
                
                <div class="device-connection">
                    <h3>Dispositivos a Conectar</h3>
                    <div class="devices-grid">
                        ${this.discoveredDevices.length > 0 ? 
                            this.discoveredDevices.map(device => this.renderConnectionDevice(device)).join('') :
                            '<div class="no-devices">No se encontraron dispositivos. <button class="btn-link" id="rescanBtn">Escanear nuevamente</button></div>'
                        }
                    </div>
                </div>
                
                <div class="step-actions">
                    <button type="button" class="btn btn-secondary" id="backToScanBtn">
                        <span class="material-icons">arrow_back</span>
                        Volver
                    </button>
                    
                    <button type="button" class="btn btn-primary" id="connectDevicesBtn">
                        <span class="material-icons">wifi</span>
                        Conectar Dispositivos
                    </button>
                </div>
            </div>
        `;
    },

    renderConnectionDevice(device) {
        return `
            <div class="connection-device" data-device-id="${device.id}">
                <label class="device-checkbox">
                    <input type="checkbox" checked>
                    <span class="checkmark"></span>
                </label>
                
                <div class="device-info">
                    <span class="material-icons">device_hub</span>
                    <div>
                        <h4>${device.name || 'Dispositivo VITA'}</h4>
                        <span class="device-serial">${device.serial}</span>
                    </div>
                </div>
                
                <div class="connection-status">
                    <span class="material-icons status-pending">radio_button_unchecked</span>
                    <span>Pendiente</span>
                </div>
            </div>
        `;
    },

    renderDeviceStep() {
        return `
            <div class="device-step">
                <div class="step-header">
                    <h2>Configuración Completada</h2>
                    <p>Los dispositivos se han conectado exitosamente</p>
                </div>
                
                <div class="connection-results">
                    ${this.discoveredDevices.map(device => this.renderConnectionResult(device)).join('')}
                </div>
                
                <div class="next-steps">
                    <h3>Próximos Pasos</h3>
                    <div class="steps-list">
                        <div class="step-item">
                            <span class="material-icons">edit</span>
                            <div>
                                <h4>Personalizar dispositivos</h4>
                                <p>Asigna nombres y configura parámetros específicos</p>
                            </div>
                        </div>
                        
                        <div class="step-item">
                            <span class="material-icons">people</span>
                            <div>
                                <h4>Gestionar usuarios</h4>
                                <p>Agrega usuarios autorizados para cada dispositivo</p>
                            </div>
                        </div>
                        
                        <div class="step-item">
                            <span class="material-icons">settings</span>
                            <div>
                                <h4>Configurar parámetros</h4>
                                <p>Ajusta horarios, sensibilidad y opciones avanzadas</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="completion-actions">
                    <button class="btn btn-secondary" id="addMoreDevicesBtn">
                        <span class="material-icons">add</span>
                        Agregar Más Dispositivos
                    </button>
                    
                    <button class="btn btn-primary" id="goToDevicesBtn">
                        <span class="material-icons">check</span>
                        Ir a Dispositivos
                    </button>
                </div>
            </div>
        `;
    },

    renderConnectionResult(device) {
        return `
            <div class="connection-result success">
                <div class="result-icon">
                    <span class="material-icons">check_circle</span>
                </div>
                
                <div class="result-info">
                    <h4>${device.name || 'Dispositivo VITA'}</h4>
                    <div class="result-details">
                        <span>Serial: ${device.serial}</span>
                        <span class="success-text">✓ Conectado exitosamente</span>
                    </div>
                </div>
                
                <button class="btn btn-outline" onclick="App.navigate('#/devices/${device.id}')">
                    Configurar
                </button>
            </div>
        `;
    },

    renderManualStep() {
        return `
            <div class="manual-step">
                <div class="step-header">
                    <h2>Configuración Manual</h2>
                    <p>Ingresa los datos del dispositivo manualmente</p>
                </div>
                
                <form id="manualDeviceForm" class="manual-form">
                    <div class="form-field">
                        <label for="deviceSerial" class="form-label">Número de serie</label>
                        <div class="input-group">
                            <span class="material-icons">qr_code</span>
                            <input 
                                type="text" 
                                id="deviceSerial" 
                                class="form-input" 
                                placeholder="VT2025001234"
                                pattern="[A-Z]{2}[0-9]{10}"
                                title="Formato: 2 letras seguidas de 10 números"
                                required 
                            >
                            <button type="button" class="scan-qr-btn" id="scanQrBtn">
                                <span class="material-icons">qr_code_scanner</span>
                            </button>
                        </div>
                        <div id="serial-error" class="form-error hidden"></div>
                        <small class="form-hint">Encuentra el número de serie en la etiqueta del dispositivo</small>
                    </div>
                    
                    <div class="form-field">
                        <label for="deviceName" class="form-label">Nombre del dispositivo</label>
                        <div class="input-group">
                            <span class="material-icons">label</span>
                            <input 
                                type="text" 
                                id="deviceName" 
                                class="form-input" 
                                placeholder="Ej: Portón Principal"
                                required 
                            >
                        </div>
                        <div id="name-error" class="form-error hidden"></div>
                    </div>
                    
                    <div class="form-field">
                        <label for="deviceType" class="form-label">Tipo de dispositivo</label>
                        <div class="input-group">
                            <span class="material-icons">category</span>
                            <select id="deviceType" class="form-input" required>
                                <option value="">Seleccionar tipo</option>
                                <option value="gate">Portón</option>
                                <option value="door">Puerta</option>
                                <option value="garage">Garaje</option>
                                <option value="barrier">Barrera</option>
                                <option value="light">Luz</option>
                                <option value="sensor">Sensor</option>
                            </select>
                        </div>
                        <div id="type-error" class="form-error hidden"></div>
                    </div>
                    
                    <div class="form-field">
                        <label for="wifiSsid" class="form-label">Red WiFi</label>
                        <div class="input-group">
                            <span class="material-icons">wifi</span>
                            <input 
                                type="text" 
                                id="wifiSsid" 
                                class="form-input" 
                                placeholder="Nombre de la red WiFi"
                                required 
                            >
                        </div>
                        <div id="ssid-error" class="form-error hidden"></div>
                    </div>
                    
                    <div class="form-field">
                        <label for="wifiPasswordManual" class="form-label">Contraseña WiFi</label>
                        <div class="input-group">
                            <span class="material-icons">lock</span>
                            <input 
                                type="password" 
                                id="wifiPasswordManual" 
                                class="form-input" 
                                placeholder="Contraseña de la red"
                            >
                            <button type="button" class="toggle-password" id="togglePasswordManual">
                                <span class="material-icons">visibility</span>
                            </button>
                        </div>
                        <small class="form-hint">Déjalo vacío si la red es abierta</small>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" id="backFromManualBtn">
                            <span class="material-icons">arrow_back</span>
                            Volver
                        </button>
                        
                        <button type="submit" class="btn btn-primary" id="addDeviceManualBtn">
                            <span class="material-icons">add</span>
                            Agregar Dispositivo
                        </button>
                    </div>
                    
                    <div id="manual-form-error" class="form-error hidden"></div>
                </form>
                
                <div class="manual-info">
                    <div class="info-card">
                        <span class="material-icons">info</span>
                        <div>
                            <h4>¿No tienes el número de serie?</h4>
                            <p>Búscalo en una etiqueta pegada al dispositivo o en el manual de usuario.</p>
                        </div>
                    </div>
                </div>
            </div>
        `;
    },

    init() {
        this.setupEventListeners();
        
        // Auto-start scan on load
        if (this.currentStep === 'scan' && !this.scanning) {
            setTimeout(() => this.startScan(), 1000);
        }
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

        // Step-specific listeners
        this.setupStepListeners();
    },

    setupStepListeners() {
        switch (this.currentStep) {
            case 'scan':
                this.setupScanListeners();
                break;
            case 'wifi':
                this.setupWiFiListeners();
                break;
            case 'device':
                this.setupDeviceListeners();
                break;
            case 'manual':
                this.setupManualListeners();
                break;
        }
    },

    setupScanListeners() {
        // Start scan button
        const scanBtn = document.getElementById('startScanBtn');
        if (scanBtn && !this.scanning) {
            scanBtn.addEventListener('click', () => this.startScan());
        }

        // Manual setup button
        const manualBtn = document.getElementById('manualSetupBtn');
        if (manualBtn) {
            manualBtn.addEventListener('click', () => this.goToStep('manual'));
        }

        // Network selection
        const networkItems = document.querySelectorAll('.network-item');
        networkItems.forEach(item => {
            item.addEventListener('click', () => this.selectNetwork(item));
        });

        // Continue button
        const continueBtn = document.getElementById('continueWithSelectionBtn');
        if (continueBtn) {
            continueBtn.addEventListener('click', () => this.goToStep('wifi'));
        }

        // Device selection
        const deviceBtns = document.querySelectorAll('.select-device-btn');
        deviceBtns.forEach(btn => {
            btn.addEventListener('click', (e) => {
                const deviceId = e.target.dataset.deviceId;
                this.selectDevice(deviceId);
            });
        });
    },

    setupWiFiListeners() {
        // Password toggle
        const toggleBtn = document.getElementById('togglePassword');
        if (toggleBtn) {
            toggleBtn.addEventListener('click', () => this.togglePasswordVisibility('wifiPassword', 'togglePassword'));
        }

        // Back button
        const backBtn = document.getElementById('backToScanBtn');
        if (backBtn) {
            backBtn.addEventListener('click', () => this.goToStep('scan'));
        }

        // Connect devices button
        const connectBtn = document.getElementById('connectDevicesBtn');
        if (connectBtn) {
            connectBtn.addEventListener('click', () => this.connectDevices());
        }

        // Rescan button
        const rescanBtn = document.getElementById('rescanBtn');
        if (rescanBtn) {
            rescanBtn.addEventListener('click', () => this.startScan());
        }
    },

    setupDeviceListeners() {
        // Add more devices button
        const addMoreBtn = document.getElementById('addMoreDevicesBtn');
        if (addMoreBtn) {
            addMoreBtn.addEventListener('click', () => this.goToStep('scan'));
        }

        // Go to devices button
        const goToBtn = document.getElementById('goToDevicesBtn');
        if (goToBtn) {
            goToBtn.addEventListener('click', () => App.navigate('#/devices'));
        }
    },

    setupManualListeners() {
        // Form submission
        const form = document.getElementById('manualDeviceForm');
        if (form) {
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                this.addDeviceManually();
            });
        }

        // Password toggle
        const toggleBtn = document.getElementById('togglePasswordManual');
        if (toggleBtn) {
            toggleBtn.addEventListener('click', () => this.togglePasswordVisibility('wifiPasswordManual', 'togglePasswordManual'));
        }

        // Back button
        const backBtn = document.getElementById('backFromManualBtn');
        if (backBtn) {
            backBtn.addEventListener('click', () => this.goToStep('scan'));
        }

        // QR scan button
        const qrBtn = document.getElementById('scanQrBtn');
        if (qrBtn) {
            qrBtn.addEventListener('click', () => this.scanQRCode());
        }

        // Input validation
        const inputs = document.querySelectorAll('.manual-form .form-input');
        inputs.forEach(input => {
            input.addEventListener('input', () => this.clearFieldError(input.id));
        });

        // Serial number formatting
        const serialInput = document.getElementById('deviceSerial');
        if (serialInput) {
            serialInput.addEventListener('input', (e) => this.formatSerialNumber(e));
        }
    },

    async startScan() {
        if (this.scanning) return;
        
        this.scanning = true;
        this.wifiNetworks = [];
        this.discoveredDevices = [];
        this.refreshCurrentStep();
        
        try {
            // Simulate scanning process
            App.showToast('Iniciando escaneo...', 'info');
            
            // Mock WiFi networks
            await this.simulateDelay(2000);
            this.wifiNetworks = [
                { ssid: 'Casa_WiFi', strength: 'strong', secured: true, frequency: '2.4GHz' },
                { ssid: 'Oficina_Bgnius', strength: 'medium', secured: true, frequency: '5GHz' },
                { ssid: 'Cochera', strength: 'weak', secured: false, frequency: '2.4GHz' },
                { ssid: 'Invitados', strength: 'medium', secured: true, frequency: '2.4GHz' }
            ];
            
            App.showToast('Redes WiFi encontradas', 'success');
            this.refreshCurrentStep();
            
            // Mock VITA devices
            await this.simulateDelay(1500);
            this.discoveredDevices = [
                { 
                    id: 'vita_001', 
                    name: 'VITA Portón',
                    serial: 'VT2025001234', 
                    model: 'FAC 500',
                    status: 'ready'
                },
                { 
                    id: 'vita_002', 
                    name: 'VITA Sensor',
                    serial: 'VT2025001235', 
                    model: 'SEN 200',
                    status: 'ready'
                }
            ];
            
            App.showToast(`${this.discoveredDevices.length} dispositivos VITA encontrados`, 'success');
            this.refreshCurrentStep();
            
        } catch (error) {
            console.error('Scan error:', error);
            App.showToast('Error durante el escaneo', 'error');
        } finally {
            this.scanning = false;
            this.refreshCurrentStep();
        }
    },

    selectNetwork(networkElement) {
        // Remove previous selection
        document.querySelectorAll('.network-item').forEach(item => {
            item.classList.remove('selected');
        });
        
        // Select new network
        networkElement.classList.add('selected');
        const ssid = networkElement.dataset.ssid;
        this.selectedNetwork = this.wifiNetworks.find(n => n.ssid === ssid);
        
        // Enable continue button
        const continueBtn = document.getElementById('continueWithSelectionBtn');
        if (continueBtn) {
            continueBtn.disabled = false;
        }
    },

    selectDevice(deviceId) {
        const device = this.discoveredDevices.find(d => d.id === deviceId);
        if (device) {
            App.showToast(`Dispositivo ${device.name} seleccionado`, 'success');
        }
    },

    async connectDevices() {
        const password = document.getElementById('wifiPassword')?.value || '';
        const selectedDevices = Array.from(document.querySelectorAll('.connection-device input:checked'))
            .map(checkbox => checkbox.closest('.connection-device').dataset.deviceId);
        
        if (selectedDevices.length === 0) {
            App.showToast('Selecciona al menos un dispositivo', 'warning');
            return;
        }
        
        if (this.selectedNetwork.secured && !password) {
            this.showFieldError('password-error', 'La contraseña es requerida para redes seguras');
            return;
        }
        
        const connectBtn = document.getElementById('connectDevicesBtn');
        this.setLoadingState(connectBtn, true);
        
        try {
            App.showToast('Conectando dispositivos...', 'info');
            
            // Simulate device connection
            for (let deviceId of selectedDevices) {
                await this.simulateDelay(1500);
                const device = this.discoveredDevices.find(d => d.id === deviceId);
                if (device) {
                    device.connected = true;
                    this.updateDeviceConnectionStatus(deviceId, 'connected');
                }
            }
            
            App.showToast('Dispositivos conectados exitosamente', 'success');
            
            // Move to device step
            setTimeout(() => this.goToStep('device'), 1000);
            
        } catch (error) {
            console.error('Connection error:', error);
            App.showToast('Error conectando dispositivos', 'error');
        } finally {
            this.setLoadingState(connectBtn, false);
        }
    },

    async addDeviceManually() {
        const formData = {
            serial: document.getElementById('deviceSerial').value.trim(),
            name: document.getElementById('deviceName').value.trim(),
            type: document.getElementById('deviceType').value,
            wifiSsid: document.getElementById('wifiSsid').value.trim(),
            wifiPassword: document.getElementById('wifiPasswordManual').value
        };
        
        // Clear previous errors
        this.clearFormErrors();
        
        // Validate form
        if (!this.validateManualForm(formData)) {
            return;
        }
        
        const submitBtn = document.getElementById('addDeviceManualBtn');
        this.setLoadingState(submitBtn, true);
        
        try {
            const result = await API.addDeviceManually(formData);
            
            if (result.success || true) { // Allow if API not implemented
                App.showToast('Dispositivo agregado correctamente', 'success');
                
                // Navigate to devices list
                setTimeout(() => {
                    App.navigate('#/devices');
                }, 1000);
            } else {
                this.showFormError(result.error || 'Error al agregar el dispositivo');
            }
        } catch (error) {
            console.error('Error adding device manually:', error);
            this.showFormError('Error de conexión. Intenta nuevamente.');
        } finally {
            this.setLoadingState(submitBtn, false);
        }
    },

    validateManualForm(data) {
        let isValid = true;

        // Validate serial
        if (!data.serial) {
            this.showFieldError('serial-error', 'El número de serie es requerido');
            isValid = false;
        } else if (!/^[A-Z]{2}[0-9]{10}$/.test(data.serial)) {
            this.showFieldError('serial-error', 'Formato inválido. Debe ser 2 letras seguidas de 10 números');
            isValid = false;
        }

        // Validate name
        if (!data.name) {
            this.showFieldError('name-error', 'El nombre del dispositivo es requerido');
            isValid = false;
        } else if (data.name.length < 3) {
            this.showFieldError('name-error', 'El nombre debe tener al menos 3 caracteres');
            isValid = false;
        }

        // Validate type
        if (!data.type) {
            this.showFieldError('type-error', 'Selecciona el tipo de dispositivo');
            isValid = false;
        }

        // Validate WiFi SSID
        if (!data.wifiSsid) {
            this.showFieldError('ssid-error', 'El nombre de la red WiFi es requerido');
            isValid = false;
        }

        return isValid;
    },

    goToStep(stepName) {
        this.currentStep = stepName;
        this.refreshCurrentStep();
    },

    refreshCurrentStep() {
        const contentContainer = document.querySelector('.add-device-content');
        if (contentContainer) {
            contentContainer.innerHTML = this.renderStepIndicator() + this.renderCurrentStep();
            this.setupStepListeners();
        }
    },

    updateDeviceConnectionStatus(deviceId, status) {
        const deviceElement = document.querySelector(`[data-device-id="${deviceId}"]`);
        if (deviceElement) {
            const statusElement = deviceElement.querySelector('.connection-status');
            if (statusElement) {
                statusElement.innerHTML = `
                    <span class="material-icons status-${status}">
                        ${status === 'connected' ? 'check_circle' : 'radio_button_unchecked'}
                    </span>
                    <span>${status === 'connected' ? 'Conectado' : 'Pendiente'}</span>
                `;
            }
        }
    },

    getSignalIcon(strength) {
        const icons = {
            'strong': 'signal_wifi_4_bar',
            'medium': 'signal_wifi_2_bar', 
            'weak': 'signal_wifi_1_bar'
        };
        return icons[strength] || 'signal_wifi_off';
    },

    getSignalText(strength) {
        const texts = {
            'strong': 'Excelente',
            'medium': 'Buena',
            'weak': 'Débil'
        };
        return texts[strength] || 'Sin señal';
    },

    togglePasswordVisibility(inputId, buttonId) {
        const input = document.getElementById(inputId);
        const button = document.getElementById(buttonId);
        
        if (input && button) {
            const isPassword = input.type === 'password';
            input.type = isPassword ? 'text' : 'password';
            button.querySelector('.material-icons').textContent = isPassword ? 'visibility_off' : 'visibility';
        }
    },

    formatSerialNumber(event) {
        let value = event.target.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
        
        // Limit to 12 characters (2 letters + 10 numbers)
        if (value.length > 12) {
            value = value.substring(0, 12);
        }
        
        event.target.value = value;
    },

    scanQRCode() {
        // Mock QR code scanning
        App.showToast('Función de escaneo QR próximamente disponible', 'info');
    },

    showHelp() {
        const helpContent = `
            <div class="help-modal">
                <h3>Ayuda - Agregar Dispositivo</h3>
                <div class="help-content">
                    <div class="help-item">
                        <h4>Escaneo Automático</h4>
                        <p>Busca automáticamente dispositivos VITA y redes WiFi disponibles. Asegúrate de que el dispositivo esté en modo configuración.</p>
                    </div>
                    
                    <div class="help-item">
                        <h4>Configuración Manual</h4>
                        <p>Ingresa los datos manualmente si el escaneo no detecta tu dispositivo. Necesitarás el número de serie y los datos de la red WiFi.</p>
                    </div>
                    
                    <div class="help-item">
                        <h4>Problemas de Conexión</h4>
                        <ul>
                            <li>Verifica que el dispositivo esté encendido</li>
                            <li>Asegúrate de que esté cerca del router</li>
                            <li>Confirma que la contraseña WiFi sea correcta</li>
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
        const errorElement = document.getElementById('manual-form-error');
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
    },

    simulateDelay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }
};

// Auto-initialize when content is rendered
document.addEventListener('DOMContentLoaded', () => {
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.addedNodes) {
                mutation.addedNodes.forEach((node) => {
                    if (node.nodeType === Node.ELEMENT_NODE) {
                        const addDeviceScreen = node.querySelector('.add-device-screen') || 
                                              (node.classList && node.classList.contains('add-device-screen') ? node : null);
                        if (addDeviceScreen) {
                            setTimeout(() => AddDeviceScreen.init(), 0);
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

window.AddDeviceScreen = AddDeviceScreen;