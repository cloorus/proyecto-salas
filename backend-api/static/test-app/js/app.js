// VITA Test App - Main Application Controller
const App = {
    currentScreen: null,
    state: {
        user: null,
        devices: [],
        currentDevice: null,
        loading: false
    },

    // Initialize the application
    init() {
        this.setupRouter();
        this.setupEventListeners();
        this.hideLoading();
        
        // Navigate to initial route
        this.handleRoute();
    },

    // Setup hash-based routing
    setupRouter() {
        window.addEventListener('hashchange', () => this.handleRoute());
        window.addEventListener('load', () => this.handleRoute());
    },

    // Setup global event listeners
    setupEventListeners() {
        // Handle back button in headers
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('header-back') || e.target.closest('.header-back')) {
                e.preventDefault();
                this.goBack();
            }
        });

        // Handle form submissions
        document.addEventListener('submit', (e) => {
            e.preventDefault();
        });
    },

    // Route handler
    handleRoute() {
        const hash = window.location.hash || '#/';
        const path = hash.slice(1); // Remove #
        
        console.log('Navigating to:', path);

        // Parse route and parameters
        const [route, ...params] = path.split('/').filter(Boolean);

        // Check authentication for protected routes
        if (route !== 'login' && !API.isAuthenticated()) {
            this.navigate('#/login');
            return;
        }

        // Route to appropriate screen
        switch (route) {
            case 'login':
                this.loadScreen('login');
                break;
            case 'register':
                this.loadScreen('register');
                break;
            case 'reset-password':
                this.loadScreen('reset-password');
                break;
            case 'devices':
                if (params.length === 0) {
                    this.loadScreen('devices');
                } else {
                    const deviceId = params[0];
                    if (params[1]) {
                        // Sub-routes for devices
                        switch (params[1]) {
                            case 'edit':
                                this.loadScreen('device-edit', { deviceId });
                                break;
                            case 'parameters':
                                this.loadScreen('device-parameters', { deviceId });
                                break;
                            case 'info':
                                this.loadScreen('device-info', { deviceId });
                                break;
                            case 'users':
                                if (params[2] === 'roles') {
                                    this.loadScreen('user-roles', { deviceId });
                                } else if (params[2] === 'link') {
                                    this.loadScreen('link-virtual-user', { deviceId });
                                } else {
                                    this.loadScreen('device-users', { deviceId });
                                }
                                break;
                            case 'events':
                                this.loadScreen('events', { deviceId });
                                break;
                            case 'control':
                                this.loadScreen('device-control-panel', { deviceId });
                                break;
                            case 'technical-contact':
                                this.loadScreen('technical-contact', { deviceId });
                                break;
                            default:
                                this.loadScreen('device-detail', { deviceId });
                        }
                    } else {
                        this.loadScreen('device-detail', { deviceId });
                    }
                }
                break;
            case 'groups':
                this.loadScreen('groups');
                break;
            case 'events':
                this.loadScreen('events');
                break;
            case 'settings':
                this.loadScreen('settings');
                break;
            case 'support':
                this.loadScreen('support');
                break;
            case 'notifications':
                this.loadScreen('notifications');
                break;
            case 'add-device':
                this.loadScreen('add-device');
                break;
            default:
                // Redirect to appropriate default route
                if (API.isAuthenticated()) {
                    this.navigate('#/devices');
                } else {
                    this.navigate('#/login');
                }
        }
    },

    // Load a screen
    async loadScreen(screenName, params = {}) {
        if (this.currentScreen === screenName) {
            return; // Already on this screen
        }

        this.currentScreen = screenName;
        this.showLoading();

        try {
            let content = '';

            switch (screenName) {
                case 'login':
                    content = LoginScreen.render();
                    break;
                case 'register':
                    content = RegisterScreen.render();
                    break;
                case 'reset-password':
                    content = ResetPasswordScreen.render();
                    break;
                case 'devices':
                    content = await DevicesScreen.render();
                    break;
                case 'device-detail':
                    content = await DeviceDetailScreen.render(params.deviceId);
                    break;
                case 'device-edit':
                    content = await DeviceEditScreen.render(params.deviceId);
                    break;
                case 'device-parameters':
                    content = await DeviceParametersScreen.render(params.deviceId);
                    break;
                case 'device-info':
                    content = await DeviceInfoScreen.render(params.deviceId);
                    break;
                case 'device-users':
                    content = await DeviceUsersScreen.render(params.deviceId);
                    break;
                case 'device-control-panel':
                    content = await DeviceControlPanelScreen.render(params.deviceId);
                    break;
                case 'groups':
                    content = await GroupsScreen.render();
                    break;
                case 'events':
                    content = await EventsScreen.render(params.deviceId);
                    break;
                case 'settings':
                    content = await SettingsScreen.render();
                    break;
                case 'support':
                    content = await SupportScreen.render();
                    break;
                case 'notifications':
                    content = await NotificationsScreen.render();
                    break;
                case 'add-device':
                    content = await AddDeviceScreen.render();
                    break;
                case 'technical-contact':
                    content = await TechnicalContactScreen.render(params.deviceId);
                    break;
                case 'user-roles':
                    content = await UserRolesScreen.render(params.deviceId);
                    break;
                case 'link-virtual-user':
                    content = await LinkVirtualUserScreen.render(params.deviceId);
                    break;
                default:
                    content = '<div class="error">Pantalla no encontrada</div>';
            }

            this.renderContent(content);
            this.hideLoading();

        } catch (error) {
            console.error('Error loading screen:', error);
            this.hideLoading();
            this.showToast('Error cargando pantalla', 'error');
        }
    },

    // Render content to the main container
    renderContent(html) {
        const contentContainer = document.getElementById('content');
        contentContainer.innerHTML = html;
    },

    // Navigation helpers
    navigate(path) {
        window.location.hash = path;
    },

    goBack() {
        window.history.back();
    },

    // Loading state management
    showLoading() {
        const loadingElement = document.getElementById('loading');
        if (loadingElement) {
            loadingElement.classList.remove('hidden');
        }
        this.state.loading = true;
    },

    hideLoading() {
        const loadingElement = document.getElementById('loading');
        if (loadingElement) {
            loadingElement.classList.add('hidden');
        }
        this.state.loading = false;
    },

    // Toast notifications
    showToast(message, type = 'info', duration = 3000) {
        const container = document.getElementById('toast-container');
        if (!container) return;

        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        toast.textContent = message;
        
        container.appendChild(toast);

        // Auto remove after duration
        setTimeout(() => {
            if (toast.parentNode === container) {
                container.removeChild(toast);
            }
        }, duration);
    },

    // Command response handler (for device actions)
    showCommandResponse(response, type = 'success') {
        // Remove any existing response
        const existing = document.querySelector('.command-response');
        if (existing) {
            existing.remove();
        }

        const responseEl = document.createElement('div');
        responseEl.className = `command-response ${type}`;
        
        if (typeof response === 'object') {
            let message = `Estado: ${response.status || 'Desconocido'}`;
            if (response.duration_ms) {
                message += ` (${response.duration_ms}ms)`;
            }
            responseEl.textContent = message;
        } else {
            responseEl.textContent = response;
        }

        document.body.appendChild(responseEl);

        // Auto remove after 5 seconds
        setTimeout(() => {
            if (responseEl.parentNode) {
                responseEl.parentNode.removeChild(responseEl);
            }
        }, 5000);
    },

    // Logout helper
    logout() {
        API.logout();
        this.state.user = null;
        this.state.devices = [];
        this.state.currentDevice = null;
        this.navigate('#/login');
        this.showToast('Sesión cerrada', 'success');
    },

    // Utility functions
    formatDeviceType(type) {
        const types = {
            'gate': 'Portón',
            'door': 'Puerta',
            'garage': 'Garaje',
            'barrier': 'Barrera',
            'light': 'Luz',
            'camera': 'Cámara',
            'sensor': 'Sensor'
        };
        return types[type] || type.charAt(0).toUpperCase() + type.slice(1);
    },

    formatDeviceStatus(isOnline) {
        return isOnline ? 'En línea' : 'Desconectado';
    },

    getDeviceIcon(type) {
        const icons = {
            'gate': 'sensor_door',
            'door': 'door_front',
            'garage': 'garage',
            'barrier': 'security',
            'light': 'lightbulb',
            'camera': 'videocam',
            'sensor': 'sensors'
        };
        return icons[type] || 'device_unknown';
    },

    // Format battery level
    formatBattery(batteryLevel) {
        if (batteryLevel === null || batteryLevel === undefined) {
            return '';
        }
        return `${batteryLevel}%`;
    },

    // Get battery icon based on level
    getBatteryIcon(batteryLevel) {
        if (batteryLevel === null || batteryLevel === undefined) {
            return '';
        }
        
        if (batteryLevel >= 80) return 'battery_full';
        if (batteryLevel >= 60) return 'battery_5_bar';
        if (batteryLevel >= 40) return 'battery_4_bar';
        if (batteryLevel >= 20) return 'battery_2_bar';
        return 'battery_alert';
    }
};

// Export for global use
window.App = App;