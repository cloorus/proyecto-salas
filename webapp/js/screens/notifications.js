// Notifications Screen Module
const NotificationsScreen = {
    notifications: [],
    
    async render() {
        try {
            // Try to get notifications from API
            const result = await API.getNotifications();
            if (result.success) {
                // Handle response format: {data: [...], pagination: {...}}
                this.notifications = Array.isArray(result.data) ? result.data : (result.data?.data || []);
            } else {
                // Mock data for development
                this.notifications = [
                    {
                        id: 1,
                        title: "Dispositivo desconectado",
                        message: "El portón principal se desconectó de la red WiFi",
                        type: "warning",
                        read: false,
                        timestamp: "2025-03-14T10:30:00Z",
                        deviceId: "device1"
                    },
                    {
                        id: 2,
                        title: "Batería baja",
                        message: "La batería del sensor de puerta está al 15%",
                        type: "error",
                        read: false,
                        timestamp: "2025-03-14T09:15:00Z",
                        deviceId: "device2"
                    },
                    {
                        id: 3,
                        title: "Usuario agregado",
                        message: "Juan Pérez fue agregado al dispositivo portón garaje",
                        type: "success",
                        read: true,
                        timestamp: "2025-03-13T16:45:00Z",
                        deviceId: "device3"
                    },
                    {
                        id: 4,
                        title: "Mantenimiento programado",
                        message: "Se programó mantenimiento para el motor casa para mañana",
                        type: "info",
                        read: true,
                        timestamp: "2025-03-13T14:20:00Z",
                        deviceId: "device4"
                    }
                ];
            }
        } catch (error) {
            console.error('Error loading notifications:', error);
            this.notifications = [];
        }

        const unreadCount = this.notifications.filter(n => !n.read).length;
        
        return `
            <div class="notifications-screen">
                <div class="header">
                    <button class="header-back">
                        <span class="material-icons">arrow_back</span>
                    </button>
                    <h1 class="header-title">Notificaciones</h1>
                    <button class="header-action" id="markAllReadBtn" ${unreadCount === 0 ? 'disabled' : ''}>
                        <span class="material-icons">done_all</span>
                    </button>
                </div>
                
                <div class="notifications-content">
                    ${this.renderNotificationTabs(unreadCount)}
                    ${this.renderNotificationsList()}
                    ${this.renderNotificationsPreferences()}
                </div>
            </div>
        `;
    },

    renderNotificationTabs(unreadCount) {
        return `
            <div class="notifications-tabs">
                <button class="tab-button active" data-tab="all">
                    <span>Todas</span>
                    <span class="badge">${this.notifications.length}</span>
                </button>
                <button class="tab-button" data-tab="unread">
                    <span>Sin leer</span>
                    ${unreadCount > 0 ? `<span class="badge">${unreadCount}</span>` : ''}
                </button>
            </div>
        `;
    },

    renderNotificationsList() {
        const filteredNotifications = this.getFilteredNotifications();
        
        if (filteredNotifications.length === 0) {
            return `
                <div class="notifications-list">
                    <div class="empty-state">
                        <span class="material-icons">notifications_none</span>
                        <p>No hay notificaciones</p>
                    </div>
                </div>
            `;
        }

        return `
            <div class="notifications-list">
                ${filteredNotifications.map(notification => this.renderNotificationItem(notification)).join('')}
            </div>
        `;
    },

    renderNotificationItem(notification) {
        const typeIcon = {
            'info': 'info',
            'success': 'check_circle',
            'warning': 'warning',
            'error': 'error'
        };

        const timeAgo = this.formatTimeAgo(notification.timestamp);
        
        return `
            <div class="notification-item ${notification.read ? 'read' : 'unread'}" data-id="${notification.id}">
                <div class="notification-icon ${notification.type}">
                    <span class="material-icons">${typeIcon[notification.type] || 'notifications'}</span>
                </div>
                
                <div class="notification-content">
                    <div class="notification-header">
                        <h3 class="notification-title">${notification.title}</h3>
                        <span class="notification-time">${timeAgo}</span>
                    </div>
                    <p class="notification-message">${notification.message}</p>
                    ${!notification.read ? '<div class="unread-indicator"></div>' : ''}
                </div>
                
                <div class="notification-actions">
                    ${!notification.read ? 
                        `<button class="mark-read-btn" data-id="${notification.id}">
                            <span class="material-icons">done</span>
                        </button>` : ''
                    }
                </div>
            </div>
        `;
    },

    renderNotificationsPreferences() {
        return `
            <div class="notification-preferences">
                <div class="section-header">
                    <span class="material-icons">settings</span>
                    <h2>Preferencias de Notificaciones</h2>
                </div>
                
                <div class="preferences-list">
                    <div class="preference-item">
                        <div class="preference-info">
                            <h3>Dispositivo desconectado</h3>
                            <p>Notificar cuando un dispositivo se desconecte</p>
                        </div>
                        <label class="toggle">
                            <input type="checkbox" checked>
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                    
                    <div class="preference-item">
                        <div class="preference-info">
                            <h3>Batería baja</h3>
                            <p>Alertas cuando la batería esté por debajo del 20%</p>
                        </div>
                        <label class="toggle">
                            <input type="checkbox" checked>
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                    
                    <div class="preference-item">
                        <div class="preference-info">
                            <h3>Actividad de usuarios</h3>
                            <p>Notificar cuando se agreguen o eliminen usuarios</p>
                        </div>
                        <label class="toggle">
                            <input type="checkbox">
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                    
                    <div class="preference-item">
                        <div class="preference-info">
                            <h3>Mantenimiento</h3>
                            <p>Recordatorios de mantenimiento programado</p>
                        </div>
                        <label class="toggle">
                            <input type="checkbox" checked>
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                </div>
            </div>
        `;
    },

    init() {
        this.currentFilter = 'all';
        this.setupEventListeners();
    },

    setupEventListeners() {
        // Back button
        const backBtn = document.querySelector('.header-back');
        if (backBtn) {
            backBtn.addEventListener('click', () => App.goBack());
        }

        // Mark all read button
        const markAllBtn = document.getElementById('markAllReadBtn');
        if (markAllBtn) {
            markAllBtn.addEventListener('click', () => this.markAllAsRead());
        }

        // Tab switching
        const tabButtons = document.querySelectorAll('.tab-button');
        tabButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                this.switchTab(e.target.dataset.tab);
            });
        });

        // Individual mark as read buttons
        const markReadBtns = document.querySelectorAll('.mark-read-btn');
        markReadBtns.forEach(button => {
            button.addEventListener('click', (e) => {
                e.stopPropagation();
                const notificationId = parseInt(e.target.dataset.id);
                this.markAsRead(notificationId);
            });
        });

        // Notification item click
        const notificationItems = document.querySelectorAll('.notification-item');
        notificationItems.forEach(item => {
            item.addEventListener('click', (e) => {
                const notificationId = parseInt(e.currentTarget.dataset.id);
                this.handleNotificationClick(notificationId);
            });
        });

        // Preference toggles
        const toggles = document.querySelectorAll('.preference-item input[type="checkbox"]');
        toggles.forEach(toggle => {
            toggle.addEventListener('change', (e) => {
                this.updatePreference(e.target);
            });
        });
    },

    switchTab(tab) {
        this.currentFilter = tab;
        
        // Update tab appearance
        document.querySelectorAll('.tab-button').forEach(btn => {
            btn.classList.remove('active');
        });
        document.querySelector(`[data-tab="${tab}"]`).classList.add('active');
        
        // Update notifications list
        const listContainer = document.querySelector('.notifications-list');
        listContainer.innerHTML = this.renderNotificationsList();
        
        // Re-attach event listeners for the new content
        this.setupNotificationListeners();
    },

    getFilteredNotifications() {
        switch (this.currentFilter) {
            case 'unread':
                return this.notifications.filter(n => !n.read);
            case 'all':
            default:
                return this.notifications;
        }
    },

    async markAsRead(notificationId) {
        try {
            // Try to update on server
            const result = await API.markNotificationRead(notificationId);
            if (!result.success) {
                console.warn('Failed to update notification on server');
            }
        } catch (error) {
            console.warn('Error updating notification:', error);
        }

        // Update local state
        const notification = this.notifications.find(n => n.id === notificationId);
        if (notification) {
            notification.read = true;
            
            // Update UI
            const item = document.querySelector(`[data-id="${notificationId}"]`);
            if (item) {
                item.classList.remove('unread');
                item.classList.add('read');
                
                const actions = item.querySelector('.notification-actions');
                if (actions) {
                    actions.innerHTML = '';
                }
                
                const indicator = item.querySelector('.unread-indicator');
                if (indicator) {
                    indicator.remove();
                }
            }
            
            // Update badges and mark all button
            this.updateBadges();
        }
    },

    async markAllAsRead() {
        const unreadNotifications = this.notifications.filter(n => !n.read);
        
        if (unreadNotifications.length === 0) return;
        
        try {
            // Try to update on server
            const result = await API.markAllNotificationsRead();
            if (!result.success) {
                console.warn('Failed to mark all notifications as read on server');
            }
        } catch (error) {
            console.warn('Error marking all notifications as read:', error);
        }

        // Update local state
        this.notifications.forEach(notification => {
            notification.read = true;
        });
        
        // Update UI
        document.querySelectorAll('.notification-item.unread').forEach(item => {
            item.classList.remove('unread');
            item.classList.add('read');
            
            const actions = item.querySelector('.notification-actions');
            if (actions) {
                actions.innerHTML = '';
            }
            
            const indicator = item.querySelector('.unread-indicator');
            if (indicator) {
                indicator.remove();
            }
        });
        
        this.updateBadges();
        App.showToast('Todas las notificaciones marcadas como leídas', 'success');
    },

    updateBadges() {
        const unreadCount = this.notifications.filter(n => !n.read).length;
        
        // Update tab badges
        const allBadge = document.querySelector('[data-tab="all"] .badge');
        if (allBadge) {
            allBadge.textContent = this.notifications.length;
        }
        
        const unreadBadge = document.querySelector('[data-tab="unread"] .badge');
        if (unreadCount > 0) {
            if (unreadBadge) {
                unreadBadge.textContent = unreadCount;
            } else {
                const unreadTab = document.querySelector('[data-tab="unread"]');
                if (unreadTab) {
                    unreadTab.innerHTML += `<span class="badge">${unreadCount}</span>`;
                }
            }
        } else {
            if (unreadBadge) {
                unreadBadge.remove();
            }
        }
        
        // Update mark all button
        const markAllBtn = document.getElementById('markAllReadBtn');
        if (markAllBtn) {
            markAllBtn.disabled = unreadCount === 0;
        }
    },

    setupNotificationListeners() {
        // Re-attach listeners for mark as read buttons
        const markReadBtns = document.querySelectorAll('.mark-read-btn');
        markReadBtns.forEach(button => {
            button.addEventListener('click', (e) => {
                e.stopPropagation();
                const notificationId = parseInt(e.target.dataset.id);
                this.markAsRead(notificationId);
            });
        });

        // Re-attach listeners for notification items
        const notificationItems = document.querySelectorAll('.notification-item');
        notificationItems.forEach(item => {
            item.addEventListener('click', (e) => {
                const notificationId = parseInt(e.currentTarget.dataset.id);
                this.handleNotificationClick(notificationId);
            });
        });
    },

    handleNotificationClick(notificationId) {
        const notification = this.notifications.find(n => n.id === notificationId);
        if (!notification) return;
        
        // Mark as read if unread
        if (!notification.read) {
            this.markAsRead(notificationId);
        }
        
        // Navigate to related device if available
        if (notification.deviceId) {
            App.navigate(`#/devices/${notification.deviceId}`);
        }
    },

    updatePreference(toggle) {
        const preference = toggle.closest('.preference-item');
        const title = preference.querySelector('h3').textContent;
        
        console.log(`Preference "${title}" ${toggle.checked ? 'enabled' : 'disabled'}`);
        
        // Here you could save preferences to API or localStorage
        try {
            const preferences = JSON.parse(localStorage.getItem('notificationPreferences') || '{}');
            preferences[title] = toggle.checked;
            localStorage.setItem('notificationPreferences', JSON.stringify(preferences));
        } catch (error) {
            console.warn('Error saving preferences:', error);
        }
    },

    formatTimeAgo(timestamp) {
        const now = new Date();
        const time = new Date(timestamp);
        const diffInMinutes = Math.floor((now - time) / (1000 * 60));
        
        if (diffInMinutes < 1) {
            return 'Ahora';
        } else if (diffInMinutes < 60) {
            return `${diffInMinutes}min`;
        } else if (diffInMinutes < 1440) {
            const hours = Math.floor(diffInMinutes / 60);
            return `${hours}h`;
        } else {
            const days = Math.floor(diffInMinutes / 1440);
            return `${days}d`;
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
                        const notificationsScreen = node.querySelector('.notifications-screen') || 
                                                  (node.classList && node.classList.contains('notifications-screen') ? node : null);
                        if (notificationsScreen) {
                            setTimeout(() => NotificationsScreen.init(), 0);
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

window.NotificationsScreen = NotificationsScreen;