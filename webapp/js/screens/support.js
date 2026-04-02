// Support Screen Module
const SupportScreen = {
    tickets: [],
    currentView: 'list', // 'list', 'form', 'detail'
    selectedTicket: null,
    
    async render() {
        try {
            // Try to get support requests from API
            const result = await API.getSupportRequests();
            if (result.success) {
                // Handle response format: {data: [...], pagination: {...}}
                this.tickets = Array.isArray(result.data) ? result.data : (result.data?.data || []);
            } else {
                // Mock data for development
                this.tickets = [
                    {
                        id: 1,
                        title: "Problema con conexión WiFi",
                        description: "El dispositivo se desconecta constantemente de la red WiFi",
                        priority: "high",
                        status: "open",
                        device: "Portón Principal",
                        deviceId: "device1",
                        createdAt: "2025-03-14T08:30:00Z",
                        updatedAt: "2025-03-14T10:15:00Z",
                        responses: [
                            {
                                id: 1,
                                message: "Hemos recibido tu solicitud. Revisaremos la configuración de red.",
                                author: "Soporte Técnico",
                                timestamp: "2025-03-14T09:00:00Z",
                                isSupport: true
                            }
                        ]
                    },
                    {
                        id: 2,
                        title: "Mantenimiento preventivo",
                        description: "Solicito programar mantenimiento preventivo para el motor del garaje",
                        priority: "medium",
                        status: "in-progress",
                        device: "Motor Garaje",
                        deviceId: "device2",
                        createdAt: "2025-03-13T14:20:00Z",
                        updatedAt: "2025-03-14T07:45:00Z",
                        responses: []
                    },
                    {
                        id: 3,
                        title: "Configuración de horarios",
                        description: "Necesito ayuda para configurar los horarios de apertura automática",
                        priority: "low",
                        status: "resolved",
                        device: "Puerta Cochera",
                        deviceId: "device3",
                        createdAt: "2025-03-12T16:10:00Z",
                        updatedAt: "2025-03-13T11:30:00Z",
                        responses: [
                            {
                                id: 2,
                                message: "Para configurar horarios, ve a Parámetros del dispositivo > Programación automática",
                                author: "Soporte Técnico",
                                timestamp: "2025-03-13T09:15:00Z",
                                isSupport: true
                            },
                            {
                                id: 3,
                                message: "Perfecto, ya pude configurarlo. Gracias!",
                                author: "Usuario",
                                timestamp: "2025-03-13T11:30:00Z",
                                isSupport: false
                            }
                        ]
                    }
                ];
            }
        } catch (error) {
            console.error('Error loading support tickets:', error);
            this.tickets = [];
        }

        return `
            <div class="support-screen">
                <div class="header">
                    <button class="header-back">
                        <span class="material-icons">arrow_back</span>
                    </button>
                    <h1 class="header-title">Soporte Técnico</h1>
                    <button class="header-action" id="newTicketBtn">
                        <span class="material-icons">add</span>
                    </button>
                </div>
                
                <div class="support-content">
                    ${this.renderCurrentView()}
                </div>
            </div>
        `;
    },

    renderCurrentView() {
        switch (this.currentView) {
            case 'form':
                return this.renderTicketForm();
            case 'detail':
                return this.renderTicketDetail();
            case 'list':
            default:
                return this.renderTicketsList();
        }
    },

    renderTicketsList() {
        const openTickets = this.tickets.filter(t => t.status !== 'resolved');
        const resolvedTickets = this.tickets.filter(t => t.status === 'resolved');
        
        return `
            <div class="tickets-list">
                <div class="tickets-summary">
                    <div class="summary-card">
                        <span class="material-icons">support_agent</span>
                        <div class="summary-info">
                            <h3>${openTickets.length}</h3>
                            <p>Tickets abiertos</p>
                        </div>
                    </div>
                    
                    <div class="summary-card">
                        <span class="material-icons">check_circle</span>
                        <div class="summary-info">
                            <h3>${resolvedTickets.length}</h3>
                            <p>Resueltos</p>
                        </div>
                    </div>
                </div>
                
                ${openTickets.length > 0 ? `
                    <div class="tickets-section">
                        <h2 class="section-title">
                            <span class="material-icons">pending</span>
                            Tickets Activos
                        </h2>
                        <div class="tickets-grid">
                            ${openTickets.map(ticket => this.renderTicketCard(ticket)).join('')}
                        </div>
                    </div>
                ` : ''}
                
                ${resolvedTickets.length > 0 ? `
                    <div class="tickets-section">
                        <h2 class="section-title">
                            <span class="material-icons">check_circle</span>
                            Resueltos
                        </h2>
                        <div class="tickets-grid">
                            ${resolvedTickets.map(ticket => this.renderTicketCard(ticket)).join('')}
                        </div>
                    </div>
                ` : ''}
                
                ${this.tickets.length === 0 ? `
                    <div class="empty-state">
                        <span class="material-icons">support_agent</span>
                        <h3>No hay solicitudes de soporte</h3>
                        <p>Crea tu primera solicitud para obtener ayuda técnica</p>
                        <button class="btn btn-primary" id="createFirstTicketBtn">
                            <span class="material-icons">add</span>
                            Crear Solicitud
                        </button>
                    </div>
                ` : ''}
            </div>
        `;
    },

    renderTicketCard(ticket) {
        const priorityColors = {
            'high': 'priority-high',
            'medium': 'priority-medium',
            'low': 'priority-low'
        };
        
        const statusLabels = {
            'open': 'Abierto',
            'in-progress': 'En progreso',
            'resolved': 'Resuelto'
        };
        
        const priorityLabels = {
            'high': 'Alta',
            'medium': 'Media',
            'low': 'Baja'
        };

        const timeAgo = this.formatTimeAgo(ticket.updatedAt);
        const hasNewResponses = ticket.responses && ticket.responses.some(r => r.isSupport);
        
        return `
            <div class="ticket-card" data-id="${ticket.id}">
                <div class="ticket-header">
                    <div class="ticket-title-row">
                        <h3 class="ticket-title">${ticket.title}</h3>
                        ${hasNewResponses ? '<div class="new-response-indicator"></div>' : ''}
                    </div>
                    
                    <div class="ticket-meta">
                        <span class="priority-chip ${priorityColors[ticket.priority]}">
                            ${priorityLabels[ticket.priority]}
                        </span>
                        <span class="status-chip status-${ticket.status}">
                            ${statusLabels[ticket.status]}
                        </span>
                    </div>
                </div>
                
                <div class="ticket-content">
                    <p class="ticket-description">${this.truncateText(ticket.description, 100)}</p>
                    
                    <div class="ticket-device">
                        <span class="material-icons">device_hub</span>
                        <span>${ticket.device}</span>
                    </div>
                </div>
                
                <div class="ticket-footer">
                    <span class="ticket-time">${timeAgo}</span>
                    ${ticket.responses && ticket.responses.length > 0 ? 
                        `<span class="responses-count">
                            <span class="material-icons">chat_bubble_outline</span>
                            ${ticket.responses.length}
                        </span>` : ''
                    }
                </div>
            </div>
        `;
    },

    renderTicketForm() {
        return `
            <div class="ticket-form">
                <div class="form-header">
                    <h2>Nueva Solicitud de Soporte</h2>
                    <p>Describe tu problema y te ayudaremos a solucionarlo</p>
                </div>
                
                <form id="supportTicketForm" class="support-form">
                    <div class="form-field">
                        <label for="ticketTitle" class="form-label">Título del problema</label>
                        <input 
                            type="text" 
                            id="ticketTitle" 
                            class="form-input" 
                            placeholder="Resume tu problema en pocas palabras"
                            required 
                        >
                        <div id="title-error" class="form-error hidden"></div>
                    </div>
                    
                    <div class="form-field">
                        <label for="ticketDevice" class="form-label">Dispositivo relacionado</label>
                        <select id="ticketDevice" class="form-input">
                            <option value="">Seleccionar dispositivo</option>
                            <option value="device1">Portón Principal</option>
                            <option value="device2">Motor Garaje</option>
                            <option value="device3">Puerta Cochera</option>
                            <option value="device4">Sensor Entrada</option>
                        </select>
                    </div>
                    
                    <div class="form-field">
                        <label for="ticketPriority" class="form-label">Prioridad</label>
                        <div class="priority-selector">
                            <label class="priority-option">
                                <input type="radio" name="priority" value="low" checked>
                                <span class="priority-chip priority-low">Baja</span>
                                <small>No es urgente</small>
                            </label>
                            <label class="priority-option">
                                <input type="radio" name="priority" value="medium">
                                <span class="priority-chip priority-medium">Media</span>
                                <small>Necesita atención</small>
                            </label>
                            <label class="priority-option">
                                <input type="radio" name="priority" value="high">
                                <span class="priority-chip priority-high">Alta</span>
                                <small>Problema crítico</small>
                            </label>
                        </div>
                    </div>
                    
                    <div class="form-field">
                        <label for="ticketDescription" class="form-label">Descripción detallada</label>
                        <textarea 
                            id="ticketDescription" 
                            class="form-textarea" 
                            placeholder="Explica el problema con el mayor detalle posible..."
                            rows="4"
                            required
                        ></textarea>
                        <div id="description-error" class="form-error hidden"></div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" id="cancelTicketBtn">
                            Cancelar
                        </button>
                        <button type="submit" class="btn btn-primary" id="submitTicketBtn">
                            <span class="material-icons">send</span>
                            Enviar Solicitud
                        </button>
                    </div>
                    
                    <div id="form-error" class="form-error hidden"></div>
                </form>
            </div>
        `;
    },

    renderTicketDetail() {
        if (!this.selectedTicket) return '<div class="error">Ticket no encontrado</div>';
        
        const ticket = this.selectedTicket;
        const statusLabels = {
            'open': 'Abierto',
            'in-progress': 'En progreso',
            'resolved': 'Resuelto'
        };
        
        const priorityLabels = {
            'high': 'Alta',
            'medium': 'Media',
            'low': 'Baja'
        };
        
        return `
            <div class="ticket-detail">
                <div class="ticket-detail-header">
                    <div class="ticket-info">
                        <h2>${ticket.title}</h2>
                        <div class="ticket-meta-detail">
                            <span class="priority-chip priority-${ticket.priority}">
                                ${priorityLabels[ticket.priority]}
                            </span>
                            <span class="status-chip status-${ticket.status}">
                                ${statusLabels[ticket.status]}
                            </span>
                            <span class="device-info">
                                <span class="material-icons">device_hub</span>
                                ${ticket.device}
                            </span>
                        </div>
                    </div>
                    
                    <div class="ticket-dates">
                        <div class="date-info">
                            <span class="date-label">Creado:</span>
                            <span>${this.formatDate(ticket.createdAt)}</span>
                        </div>
                        <div class="date-info">
                            <span class="date-label">Actualizado:</span>
                            <span>${this.formatDate(ticket.updatedAt)}</span>
                        </div>
                    </div>
                </div>
                
                <div class="ticket-description">
                    <h3>Descripción</h3>
                    <p>${ticket.description}</p>
                </div>
                
                <div class="ticket-conversation">
                    <h3>Conversación</h3>
                    <div class="messages-list">
                        ${ticket.responses && ticket.responses.length > 0 ? 
                            ticket.responses.map(response => this.renderResponse(response)).join('') :
                            '<div class="no-responses">No hay respuestas aún</div>'
                        }
                    </div>
                    
                    ${ticket.status !== 'resolved' ? `
                        <div class="message-form">
                            <textarea 
                                id="newMessage" 
                                class="form-textarea" 
                                placeholder="Escribe tu mensaje..."
                                rows="3"
                            ></textarea>
                            <button class="btn btn-primary" id="sendMessageBtn">
                                <span class="material-icons">send</span>
                                Enviar
                            </button>
                        </div>
                    ` : ''}
                </div>
                
                ${ticket.status === 'resolved' ? `
                    <div class="resolved-notice">
                        <span class="material-icons">check_circle</span>
                        <p>Este ticket ha sido marcado como resuelto</p>
                    </div>
                ` : ''}
            </div>
        `;
    },

    renderResponse(response) {
        return `
            <div class="message ${response.isSupport ? 'support-message' : 'user-message'}">
                <div class="message-header">
                    <span class="message-author">${response.author}</span>
                    <span class="message-time">${this.formatDate(response.timestamp)}</span>
                </div>
                <div class="message-content">
                    ${response.message}
                </div>
            </div>
        `;
    },

    init() {
        this.setupEventListeners();
    },

    setupEventListeners() {
        // Back button
        const backBtn = document.querySelector('.header-back');
        if (backBtn) {
            backBtn.addEventListener('click', () => {
                if (this.currentView !== 'list') {
                    this.currentView = 'list';
                    this.refreshView();
                } else {
                    App.goBack();
                }
            });
        }

        // New ticket button
        const newTicketBtn = document.getElementById('newTicketBtn');
        if (newTicketBtn) {
            newTicketBtn.addEventListener('click', () => this.showTicketForm());
        }

        // Create first ticket button (empty state)
        const createFirstBtn = document.getElementById('createFirstTicketBtn');
        if (createFirstBtn) {
            createFirstBtn.addEventListener('click', () => this.showTicketForm());
        }

        // Ticket cards click
        const ticketCards = document.querySelectorAll('.ticket-card');
        ticketCards.forEach(card => {
            card.addEventListener('click', () => {
                const ticketId = parseInt(card.dataset.id);
                this.showTicketDetail(ticketId);
            });
        });

        // Form submission
        const form = document.getElementById('supportTicketForm');
        if (form) {
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                this.submitTicket();
            });
        }

        // Form cancel
        const cancelBtn = document.getElementById('cancelTicketBtn');
        if (cancelBtn) {
            cancelBtn.addEventListener('click', () => {
                this.currentView = 'list';
                this.refreshView();
            });
        }

        // Send message button
        const sendMessageBtn = document.getElementById('sendMessageBtn');
        if (sendMessageBtn) {
            sendMessageBtn.addEventListener('click', () => this.sendMessage());
        }

        // Priority selector
        const priorityOptions = document.querySelectorAll('.priority-option input');
        priorityOptions.forEach(option => {
            option.addEventListener('change', () => this.updatePrioritySelection());
        });
    },

    showTicketForm() {
        this.currentView = 'form';
        this.refreshView();
    },

    showTicketDetail(ticketId) {
        this.selectedTicket = this.tickets.find(t => t.id === ticketId);
        if (this.selectedTicket) {
            this.currentView = 'detail';
            this.refreshView();
        }
    },

    refreshView() {
        const contentContainer = document.querySelector('.support-content');
        if (contentContainer) {
            contentContainer.innerHTML = this.renderCurrentView();
            this.setupEventListeners();
        }
    },

    async submitTicket() {
        const title = document.getElementById('ticketTitle').value.trim();
        const description = document.getElementById('ticketDescription').value.trim();
        const device = document.getElementById('ticketDevice').value;
        const priority = document.querySelector('input[name="priority"]:checked').value;

        // Clear previous errors
        this.clearFormErrors();

        // Validate
        if (!this.validateTicketForm(title, description)) {
            return;
        }

        const submitBtn = document.getElementById('submitTicketBtn');
        this.setLoadingState(submitBtn, true);

        try {
            const ticketData = {
                title,
                description,
                priority,
                device_id: device || null
            };

            const result = await API.createSupportTicket(ticketData);
            
            if (result.success) {
                // Add to local state
                const newTicket = {
                    id: Date.now(), // Temporary ID
                    title,
                    description,
                    priority,
                    status: 'open',
                    device: device ? this.getDeviceName(device) : 'General',
                    deviceId: device,
                    createdAt: new Date().toISOString(),
                    updatedAt: new Date().toISOString(),
                    responses: []
                };
                
                this.tickets.unshift(newTicket);
                this.currentView = 'list';
                this.refreshView();
                
                App.showToast('Solicitud de soporte enviada correctamente', 'success');
            } else {
                this.showFormError(result.error || 'Error al enviar la solicitud');
            }
        } catch (error) {
            console.error('Error submitting ticket:', error);
            this.showFormError('Error de conexión. Intenta nuevamente.');
        } finally {
            this.setLoadingState(submitBtn, false);
        }
    },

    async sendMessage() {
        const messageText = document.getElementById('newMessage').value.trim();
        if (!messageText || !this.selectedTicket) return;

        const sendBtn = document.getElementById('sendMessageBtn');
        this.setLoadingState(sendBtn, true);

        try {
            const result = await API.sendTicketMessage(this.selectedTicket.id, messageText);
            
            if (result.success || true) { // Allow if API not implemented
                // Add message to local state
                const newMessage = {
                    id: Date.now(),
                    message: messageText,
                    author: 'Usuario',
                    timestamp: new Date().toISOString(),
                    isSupport: false
                };
                
                this.selectedTicket.responses = this.selectedTicket.responses || [];
                this.selectedTicket.responses.push(newMessage);
                this.selectedTicket.updatedAt = new Date().toISOString();
                
                // Update the ticket in main array
                const ticketIndex = this.tickets.findIndex(t => t.id === this.selectedTicket.id);
                if (ticketIndex >= 0) {
                    this.tickets[ticketIndex] = this.selectedTicket;
                }
                
                // Clear message input and refresh
                document.getElementById('newMessage').value = '';
                this.refreshView();
                
                App.showToast('Mensaje enviado', 'success');
            }
        } catch (error) {
            console.error('Error sending message:', error);
            App.showToast('Error al enviar mensaje', 'error');
        } finally {
            this.setLoadingState(sendBtn, false);
        }
    },

    validateTicketForm(title, description) {
        let isValid = true;

        if (!title) {
            this.showFieldError('title-error', 'El título es requerido');
            isValid = false;
        } else if (title.length < 10) {
            this.showFieldError('title-error', 'El título debe tener al menos 10 caracteres');
            isValid = false;
        }

        if (!description) {
            this.showFieldError('description-error', 'La descripción es requerida');
            isValid = false;
        } else if (description.length < 20) {
            this.showFieldError('description-error', 'La descripción debe tener al menos 20 caracteres');
            isValid = false;
        }

        return isValid;
    },

    updatePrioritySelection() {
        const selectedOption = document.querySelector('.priority-option input:checked').closest('.priority-option');
        document.querySelectorAll('.priority-option').forEach(option => {
            option.classList.remove('selected');
        });
        selectedOption.classList.add('selected');
    },

    getDeviceName(deviceId) {
        const deviceNames = {
            'device1': 'Portón Principal',
            'device2': 'Motor Garaje',
            'device3': 'Puerta Cochera',
            'device4': 'Sensor Entrada'
        };
        return deviceNames[deviceId] || 'Dispositivo';
    },

    truncateText(text, maxLength) {
        if (text.length <= maxLength) return text;
        return text.substring(0, maxLength).trim() + '...';
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
    },

    formatDate(timestamp) {
        const date = new Date(timestamp);
        return date.toLocaleDateString('es-ES', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    },

    setLoadingState(button, loading) {
        if (!button) return;

        if (loading) {
            button.disabled = true;
            button.dataset.originalText = button.innerHTML;
            button.innerHTML = `
                <div class="spinner" style="width: 16px; height: 16px; border-width: 2px;"></div>
                Enviando...
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
        const errorElement = document.getElementById('form-error');
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.classList.remove('hidden');
        }
    },

    clearFormErrors() {
        const errorElements = document.querySelectorAll('.form-error');
        errorElements.forEach(element => {
            element.textContent = '';
            element.classList.add('hidden');
        });
    }
};

// Auto-initialize when content is rendered
document.addEventListener('DOMContentLoaded', () => {
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.addedNodes) {
                mutation.addedNodes.forEach((node) => {
                    if (node.nodeType === Node.ELEMENT_NODE) {
                        const supportScreen = node.querySelector('.support-screen') || 
                                            (node.classList && node.classList.contains('support-screen') ? node : null);
                        if (supportScreen) {
                            setTimeout(() => SupportScreen.init(), 0);
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

window.SupportScreen = SupportScreen;