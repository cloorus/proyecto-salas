// VITA - Device Events Screen
const DeviceEventsScreen = {
    async render(deviceId) {
        const result = await API.getDeviceEvents(deviceId);
        let events = [];
        if (result.success) {
            events = result.data.data || result.data || [];
        }

        return `
            <div class="screen events-screen">
                <div class="app-header">
                    <button class="header-back" onclick="history.back()"><span class="material-icons">arrow_back</span></button>
                    <h1 class="header-title">Eventos</h1>
                    <img src="images/IconoLogo_transparente.png" class="header-logo" alt="BGnius">
                </div>
                <div class="screen-content" style="padding:16px">
                    ${events.length === 0 ? `
                        <div class="empty-state">
                            <span class="material-icons">event_note</span>
                            <p>No hay eventos registrados</p>
                        </div>
                    ` : `
                        <div class="events-timeline">
                            ${events.map(ev => {
                                const date = ev.timestamp ? new Date(ev.timestamp) : null;
                                const dateStr = date ? date.toLocaleDateString('es-ES', { day: '2-digit', month: 'short' }) : '';
                                const timeStr = date ? date.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' }) : '';
                                const icon = DeviceEventsScreen.getEventIcon(ev.type);
                                return `
                                    <div class="event-item">
                                        <div class="event-timeline-dot">
                                            <span class="material-icons">${icon}</span>
                                        </div>
                                        <div class="event-content">
                                            <div class="event-header">
                                                <span class="event-type">${ev.type || 'Evento'}</span>
                                                <span class="event-time">${dateStr} ${timeStr}</span>
                                            </div>
                                            <p class="event-description">${ev.description || ''}</p>
                                        </div>
                                    </div>
                                `;
                            }).join('')}
                        </div>
                    `}
                </div>
            </div>
        `;
    },

    getEventIcon(type) {
        const icons = {
            'command': 'terminal', 'open': 'lock_open', 'close': 'lock',
            'online': 'wifi', 'offline': 'wifi_off', 'alert': 'warning',
            'error': 'error', 'battery': 'battery_alert',
        };
        return icons[type] || 'event';
    }
};
window.DeviceEventsScreen = DeviceEventsScreen;
