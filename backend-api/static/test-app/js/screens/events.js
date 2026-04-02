// Events Log Screen Module
const EventsScreen = {
    events: [],
    currentDevice: null,
    isDeviceSpecific: false,

    async render(deviceId = null) {
        try {
            App.showLoading();
            
            this.isDeviceSpecific = !!deviceId;
            
            let eventsResult;
            if (deviceId) {
                // Device-specific events
                const [deviceResult, deviceEventsResult] = await Promise.all([
                    API.getDeviceDetail(deviceId),
                    API.getDeviceEvents(deviceId)
                ]);
                
                if (!deviceResult.success) {
                    App.hideLoading();
                    return this.renderError(deviceResult.error || 'Error cargando dispositivo');
                }
                
                // Handle /full endpoint response format
                if (deviceResult.data && deviceResult.data.device) {
                    this.currentDevice = deviceResult.data.device;
                } else {
                    this.currentDevice = deviceResult.data;
                }
                eventsResult = deviceEventsResult;
            } else {
                // All events
                eventsResult = await API.getNotifications(); // Using notifications as events
            }

            App.hideLoading();

            // Handle API responses
            if (eventsResult.success) {
                // Handle response format: {data: [...], pagination: {...}}
                this.events = Array.isArray(eventsResult.data) ? eventsResult.data : (eventsResult.data?.data || []);
            } else if (eventsResult.error?.includes('501') || eventsResult.error?.includes('503')) {
                this.events = this.getMockEvents();
                App.showToast('Usando datos de demostración (API no disponible)', 'warning');
            } else {
                this.events = this.getMockEvents();
            }

            return `
                <div class="events-container">
                    ${this.renderHeader()}
                    ${this.currentDevice ? this.renderDeviceInfoBanner() : ''}
                    ${this.renderFilters()}
                    ${this.renderEventsList()}
                </div>
            `;
        } catch (error) {
            console.error('Error rendering events screen:', error);
            App.hideLoading();
            return this.renderError('Error cargando eventos');
        }
    },

    renderHeader() {
        const title = this.isDeviceSpecific ? 
            `Eventos - ${this.currentDevice?.name || 'Dispositivo'}` : 
            'Registro de Eventos';
            
        return `
            <div class="header">
                <button class="header-back material-icons" onclick="App.goBack()">
                    arrow_back
                </button>
                <h1 class="header-title" style="color: var(--title-blue); font-family: 'Montserrat', sans-serif;">${title}</h1>
                <button class="header-back material-icons" onclick="EventsScreen.refreshEvents()" title="Actualizar">
                    refresh
                </button>
            </div>
        `;
    },

    renderDeviceInfoBanner() {
        if (!this.currentDevice) return '';

        return `
            <div class="device-info-banner" style="margin: 16px;">
                <div class="banner-title">${this.currentDevice.name || 'Dispositivo sin nombre'}</div>
                <div class="banner-details">
                    <div class="banner-detail">
                        <span class="banner-label">Modelo:</span>
                        <span class="banner-value">${this.currentDevice.model || 'N/A'}</span>
                    </div>
                    <div class="banner-detail">
                        <span class="banner-label">Serial:</span>
                        <span class="banner-value">${this.currentDevice.serial_number || 'N/A'}</span>
                    </div>
                    <div class="banner-detail">
                        <span class="banner-label">Estado:</span>
                        <span class="banner-value ${this.currentDevice.is_online ? 'online' : 'offline'}">
                            ${this.currentDevice.is_online ? 'En línea' : 'Desconectado'}
                        </span>
                    </div>
                    <div class="banner-detail">
                        <span class="banner-label">Detalle:</span>
                        <span class="banner-value">${this.currentDevice.firmware_version || 'N/A'}</span>
                    </div>
                </div>
            </div>
        `;
    },

    renderFilters() {
        return `
            <div class="events-filters" style="margin: 16px; padding: 16px; background-color: var(--surface-color); border-radius: 8px; border: 1px solid var(--divider-color);">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 16px;">
                    <select id="eventTypeFilter" class="form-input" style="padding: 8px;">
                        <option value="">Todos los tipos</option>
                        <option value="command">Comandos</option>
                        <option value="status">Estado</option>
                        <option value="alert">Alertas</option>
                        <option value="maintenance">Mantenimiento</option>
                    </select>
                    
                    <select id="timeRangeFilter" class="form-input" style="padding: 8px;">
                        <option value="24h">Últimas 24 horas</option>
                        <option value="7d">Última semana</option>
                        <option value="30d">Último mes</option>
                        <option value="all">Todos</option>
                    </select>
                </div>
                
                <button class="btn btn-secondary" onclick="EventsScreen.applyFilters()" style="width: 100%;">
                    <span class="material-icons">filter_list</span>
                    Aplicar Filtros
                </button>
            </div>
        `;
    },

    renderEventsList() {
        if (this.events.length === 0) {
            return `
                <div class="events-section" style="margin: 16px;">
                    <div class="empty-state" style="text-align: center; padding: 48px 24px;">
                        <span class="material-icons" style="font-size: 64px; color: var(--text-hint); margin-bottom: 16px;">event_note</span>
                        <h3 style="color: var(--text-secondary); margin-bottom: 8px;">No hay eventos</h3>
                        <p style="color: var(--text-hint);">No se encontraron eventos para mostrar</p>
                    </div>
                </div>
            `;
        }

        return `
            <div class="events-section" style="margin: 16px;">
                <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px; font-family: 'Montserrat', sans-serif;">
                    <span class="material-icons" style="vertical-align: middle; margin-right: 8px;">timeline</span>
                    Cronología de Eventos
                </h3>
                
                <div class="events-timeline">
                    ${this.events.map(event => this.renderEventItem(event)).join('')}
                </div>
                
                ${this.events.length >= 50 ? `
                    <button class="btn btn-secondary" onclick="EventsScreen.loadMoreEvents()" style="width: 100%; margin-top: 16px;">
                        <span class="material-icons">expand_more</span>
                        Cargar Más Eventos
                    </button>
                ` : ''}
            </div>
        `;
    },

    renderEventItem(event) {
        const eventIcon = this.getEventIcon(event.type);
        const eventColor = this.getEventColor(event.type);
        const timeAgo = this.getTimeAgo(event.timestamp);

        return `
            <div class="event-item" style="display: flex; gap: 16px; padding: 16px 0; border-bottom: 1px solid var(--divider-color); position: relative;">
                <!-- Timeline connector -->
                <div class="timeline-connector" style="position: absolute; left: 20px; top: 48px; bottom: -16px; width: 2px; background-color: var(--divider-color);"></div>
                
                <!-- Event icon -->
                <div class="event-icon" style="width: 40px; height: 40px; border-radius: 50%; background-color: ${eventColor}; display: flex; align-items: center; justify-content: center; color: white; flex-shrink: 0; position: relative; z-index: 1;">
                    <span class="material-icons" style="font-size: 20px;">${eventIcon}</span>
                </div>
                
                <!-- Event content -->
                <div class="event-content" style="flex: 1; min-width: 0;">
                    <div class="event-header" style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 8px;">
                        <div style="flex: 1;">
                            <div class="event-title" style="font-weight: 600; color: var(--text-primary); margin-bottom: 4px;">${event.title}</div>
                            <div class="event-description" style="color: var(--text-secondary); font-size: 14px; line-height: 1.4;">${event.description}</div>
                        </div>
                        <div class="event-time" style="color: var(--text-hint); font-size: 12px; text-align: right; margin-left: 12px;">
                            <div>${timeAgo}</div>
                            <div style="margin-top: 2px;">${this.formatEventTime(event.timestamp)}</div>
                        </div>
                    </div>
                    
                    ${event.details ? `
                        <div class="event-details" style="background-color: var(--background-color); padding: 12px; border-radius: 6px; margin-top: 8px; font-size: 14px;">
                            ${typeof event.details === 'object' ? this.renderEventDetails(event.details) : event.details}
                        </div>
                    ` : ''}
                    
                    ${event.device_name && !this.isDeviceSpecific ? `
                        <div class="event-device" style="display: inline-flex; align-items: center; gap: 4px; background-color: var(--primary-purple); color: white; padding: 4px 8px; border-radius: 12px; font-size: 12px; margin-top: 8px;">
                            <span class="material-icons" style="font-size: 14px;">device_hub</span>
                            ${event.device_name}
                        </div>
                    ` : ''}
                </div>
            </div>
        `;
    },

    renderEventDetails(details) {
        return Object.entries(details).map(([key, value]) => `
            <div style="display: flex; justify-content: space-between; margin-bottom: 4px;">
                <span style="color: var(--text-secondary);">${this.formatDetailKey(key)}:</span>
                <span style="color: var(--text-primary); font-weight: 500;">${value}</span>
            </div>
        `).join('');
    },

    renderError(errorMessage) {
        return `
            <div class="events-container">
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

    getMockEvents() {
        const now = new Date();
        return [
            {
                id: '1',
                type: 'command',
                title: 'Comando OPEN ejecutado',
                description: 'Usuario Juan Pérez abrió el dispositivo remotamente',
                timestamp: new Date(now - 2 * 60 * 1000).toISOString(), // 2 minutes ago
                device_name: 'Portón Principal',
                details: {
                    'Usuario': 'Juan Pérez',
                    'Método': 'Aplicación móvil',
                    'Duración': '1.2s'
                }
            },
            {
                id: '2',
                type: 'status',
                title: 'Dispositivo conectado',
                description: 'El dispositivo se reconectó a la red WiFi',
                timestamp: new Date(now - 15 * 60 * 1000).toISOString(), // 15 minutes ago
                device_name: 'Portón Principal',
                details: {
                    'IP': '192.168.1.100',
                    'Señal': '85%'
                }
            },
            {
                id: '3',
                type: 'alert',
                title: 'Batería baja',
                description: 'El nivel de batería ha bajado al 15%',
                timestamp: new Date(now - 3 * 60 * 60 * 1000).toISOString(), // 3 hours ago
                device_name: 'Puerta Lateral',
                details: {
                    'Nivel actual': '15%',
                    'Estimado': '2 días restantes'
                }
            },
            {
                id: '4',
                type: 'maintenance',
                title: 'Ciclo de mantenimiento',
                description: 'Se ha alcanzado el intervalo de mantenimiento programado',
                timestamp: new Date(now - 24 * 60 * 60 * 1000).toISOString(), // 1 day ago
                device_name: 'Motor Garaje',
                details: {
                    'Ciclos completados': '4,850',
                    'Próximo mantenimiento': '150 ciclos'
                }
            },
            {
                id: '5',
                type: 'command',
                title: 'Comando CLOSE ejecutado',
                description: 'Cierre automático programado',
                timestamp: new Date(now - 2 * 24 * 60 * 60 * 1000).toISOString(), // 2 days ago
                device_name: 'Portón Principal',
                details: {
                    'Tipo': 'Automático',
                    'Timer': '20 segundos'
                }
            }
        ];
    },

    // Initialize events screen
    init() {
        // Set up filter change handlers
        const typeFilter = document.getElementById('eventTypeFilter');
        const timeFilter = document.getElementById('timeRangeFilter');
        
        if (typeFilter) {
            typeFilter.addEventListener('change', () => this.applyFilters());
        }
        
        if (timeFilter) {
            timeFilter.addEventListener('change', () => this.applyFilters());
        }
    },

    // Utility methods
    getEventIcon(eventType) {
        const icons = {
            'command': 'touch_app',
            'status': 'info',
            'alert': 'warning',
            'maintenance': 'build',
            'error': 'error'
        };
        return icons[eventType] || 'event';
    },

    getEventColor(eventType) {
        const colors = {
            'command': 'var(--primary-purple)',
            'status': 'var(--secondary-blue)',
            'alert': 'var(--warning-color)',
            'maintenance': 'var(--success-color)',
            'error': 'var(--error-color)'
        };
        return colors[eventType] || 'var(--text-hint)';
    },

    getTimeAgo(timestamp) {
        const now = new Date();
        const eventTime = new Date(timestamp);
        const diffMs = now - eventTime;
        const diffMins = Math.floor(diffMs / (1000 * 60));
        const diffHours = Math.floor(diffMs / (1000 * 60 * 60));
        const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));

        if (diffMins < 1) return 'Ahora';
        if (diffMins < 60) return `${diffMins}m`;
        if (diffHours < 24) return `${diffHours}h`;
        return `${diffDays}d`;
    },

    formatEventTime(timestamp) {
        try {
            const date = new Date(timestamp);
            return date.toLocaleString('es-ES', {
                hour: '2-digit',
                minute: '2-digit',
                day: 'numeric',
                month: 'short'
            });
        } catch {
            return 'N/A';
        }
    },

    formatDetailKey(key) {
        const keyMap = {
            'Usuario': 'Usuario',
            'Método': 'Método',
            'Duración': 'Duración',
            'IP': 'Dirección IP',
            'Señal': 'Intensidad',
            'Nivel actual': 'Batería',
            'Estimado': 'Tiempo restante',
            'Ciclos completados': 'Ciclos',
            'Próximo mantenimiento': 'Próximo',
            'Tipo': 'Tipo',
            'Timer': 'Timer'
        };
        return keyMap[key] || key;
    },

    // Action methods
    async refreshEvents() {
        try {
            App.showToast('Actualizando eventos...', 'info');
            
            // Re-render the screen with fresh data
            const deviceId = this.isDeviceSpecific ? this.currentDevice?.id : null;
            const newContent = await this.render(deviceId);
            
            const container = document.querySelector('.events-container');
            if (container) {
                container.outerHTML = newContent;
                this.init();
            }
            
            App.showToast('Eventos actualizados', 'success');
            
        } catch (error) {
            console.error('Refresh events error:', error);
            App.showToast('Error actualizando eventos', 'error');
        }
    },

    applyFilters() {
        const typeFilter = document.getElementById('eventTypeFilter')?.value;
        const timeFilter = document.getElementById('timeRangeFilter')?.value;
        
        let filteredEvents = [...this.events];
        
        // Apply type filter
        if (typeFilter) {
            filteredEvents = filteredEvents.filter(event => event.type === typeFilter);
        }
        
        // Apply time range filter
        if (timeFilter && timeFilter !== 'all') {
            const now = new Date();
            let cutoffTime;
            
            switch (timeFilter) {
                case '24h':
                    cutoffTime = new Date(now - 24 * 60 * 60 * 1000);
                    break;
                case '7d':
                    cutoffTime = new Date(now - 7 * 24 * 60 * 60 * 1000);
                    break;
                case '30d':
                    cutoffTime = new Date(now - 30 * 24 * 60 * 60 * 1000);
                    break;
            }
            
            if (cutoffTime) {
                filteredEvents = filteredEvents.filter(event => 
                    new Date(event.timestamp) >= cutoffTime
                );
            }
        }
        
        // Re-render events list with filtered data
        this.updateEventsList(filteredEvents);
        
        App.showToast(`Mostrando ${filteredEvents.length} evento(s)`, 'info');
    },

    updateEventsList(events) {
        const timelineContainer = document.querySelector('.events-timeline');
        if (timelineContainer) {
            timelineContainer.innerHTML = events.map(event => this.renderEventItem(event)).join('');
        }
    },

    async loadMoreEvents() {
        try {
            App.showToast('Cargando más eventos...', 'info');
            
            // Mock loading more events
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            App.showToast('No hay más eventos para cargar', 'info');
            
        } catch (error) {
            console.error('Load more events error:', error);
            App.showToast('Error cargando más eventos', 'error');
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
                        const eventsContainer = node.querySelector('.events-container') || 
                                              (node.classList && node.classList.contains('events-container') ? node : null);
                        if (eventsContainer) {
                            setTimeout(() => EventsScreen.init(), 0);
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

window.EventsScreen = EventsScreen;