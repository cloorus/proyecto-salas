// Groups Management Screen Module
const GroupsScreen = {
    groups: [],
    devices: [],
    selectedGroup: null,

    async render() {
        try {
            App.showLoading();

            // Fetch groups and devices
            const [groupsResult, devicesResult] = await Promise.all([
                API.getGroups(),
                API.getDevices()
            ]);

            App.hideLoading();

            // Handle API responses
            if (groupsResult.success) {
                this.groups = groupsResult.data?.data || [];
            } else if (groupsResult.error?.includes('501')) {
                this.groups = this.getMockGroups();
                App.showToast('Usando datos de demostración (API no disponible)', 'warning');
            } else {
                this.groups = this.getMockGroups();
            }

            this.devices = devicesResult.success ? (devicesResult.data?.data || []) : [];

            return `
                <div class="groups-container">
                    ${this.renderHeader()}
                    ${this.renderGroupsList()}
                    ${this.renderSelectedGroupDevices()}
                    ${this.renderAllDevices()}
                    ${this.renderActions()}
                </div>
            `;
        } catch (error) {
            console.error('Error rendering groups screen:', error);
            App.hideLoading();
            return this.renderError('Error cargando grupos');
        }
    },

    renderHeader() {
        return `
            <div class="header">
                <button class="header-back material-icons" onclick="App.goBack()">
                    arrow_back
                </button>
                <h1 class="header-title" style="color: var(--title-blue); font-family: 'Montserrat', sans-serif;">Grupos</h1>
                <button class="header-back material-icons" onclick="GroupsScreen.createGroup()" title="Crear Grupo">
                    add
                </button>
            </div>
        `;
    },

    renderGroupsList() {
        return `
            <div class="groups-section" style="margin: 16px;">
                <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px; font-family: 'Montserrat', sans-serif;">
                    <span class="material-icons" style="vertical-align: middle; margin-right: 8px;">group_work</span>
                    Mis Grupos
                </h3>
                
                <div class="groups-grid" style="display: grid; gap: 12px;">
                    ${this.groups.length > 0 ? 
                        this.groups.map(group => this.renderGroupCard(group)).join('') :
                        '<div class="empty-state" style="text-align: center; padding: 32px; color: var(--text-secondary);">No hay grupos creados</div>'
                    }
                </div>
            </div>
        `;
    },

    renderGroupCard(group) {
        const isSelected = this.selectedGroup?.id === group.id;
        const deviceCount = group.device_count || 0;

        return `
            <div class="group-card ${isSelected ? 'selected' : ''}" 
                 onclick="GroupsScreen.selectGroup('${group.id}')"
                 style="padding: 16px; background-color: var(--surface-color); border-radius: 8px; border: 2px solid ${isSelected ? 'var(--primary-purple)' : 'var(--divider-color)'}; cursor: pointer; transition: all 0.2s;">
                
                <div style="display: flex; align-items: center; gap: 16px;">
                    <div class="group-icon" style="width: 48px; height: 48px; border-radius: 12px; background: linear-gradient(135deg, var(--primary-purple), var(--accent-purple)); display: flex; align-items: center; justify-content: center; color: white;">
                        <span class="material-icons">folder</span>
                    </div>
                    
                    <div style="flex: 1;">
                        <div class="group-name" style="font-weight: 600; color: var(--text-primary); margin-bottom: 4px;">${group.name}</div>
                        <div class="group-description" style="color: var(--text-secondary); font-size: 14px; margin-bottom: 4px;">${group.description || 'Sin descripción'}</div>
                        <div class="group-stats" style="display: flex; align-items: center; gap: 16px; font-size: 12px; color: var(--text-hint);">
                            <span style="display: flex; align-items: center; gap: 4px;">
                                <span class="material-icons" style="font-size: 14px;">devices</span>
                                ${deviceCount} dispositivo${deviceCount !== 1 ? 's' : ''}
                            </span>
                            <span style="display: flex; align-items: center; gap: 4px;">
                                <span class="material-icons" style="font-size: 14px;">schedule</span>
                                ${this.formatDate(group.created_at)}
                            </span>
                        </div>
                    </div>
                    
                    <div class="group-actions" onclick="event.stopPropagation()">
                        <button class="btn" onclick="GroupsScreen.editGroup('${group.id}')" style="padding: 8px; background: none; color: var(--primary-purple); border: 1px solid var(--primary-purple);">
                            <span class="material-icons" style="font-size: 16px;">edit</span>
                        </button>
                    </div>
                </div>
            </div>
        `;
    },

    renderSelectedGroupDevices() {
        if (!this.selectedGroup) return '';

        const groupDevices = this.devices.filter(device => device.group_id === this.selectedGroup.id);

        return `
            <div class="group-devices-section" style="margin: 16px;">
                <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px; font-family: 'Montserrat', sans-serif;">
                    <span class="material-icons" style="vertical-align: middle; margin-right: 8px;">devices</span>
                    Dispositivos en ${this.selectedGroup.name}
                </h3>
                
                <div class="group-devices-list">
                    ${groupDevices.length > 0 ? 
                        groupDevices.map(device => this.renderGroupDevice(device)).join('') :
                        '<div class="empty-state" style="text-align: center; padding: 24px; color: var(--text-secondary);">No hay dispositivos en este grupo</div>'
                    }
                </div>
                
                <button class="btn btn-primary" onclick="GroupsScreen.addDeviceToGroup()" style="margin-top: 16px; width: 100%;">
                    <span class="material-icons">add</span>
                    Agregar Dispositivo al Grupo
                </button>
            </div>
        `;
    },

    renderGroupDevice(device) {
        return `
            <div class="device-in-group" style="display: flex; align-items: center; gap: 16px; padding: 12px; background-color: var(--surface-color); border-radius: 8px; margin-bottom: 8px; border: 1px solid var(--divider-color);">
                <div class="device-icon" style="width: 40px; height: 40px; border-radius: 50%; background-color: var(--primary-purple); display: flex; align-items: center; justify-content: center; color: white;">
                    <span class="material-icons" style="font-size: 20px;">${App.getDeviceIcon(device.device_type)}</span>
                </div>
                
                <div style="flex: 1;">
                    <div class="device-name" style="font-weight: 500; color: var(--text-primary);">${device.name}</div>
                    <div class="device-status" style="font-size: 14px; color: var(--text-secondary);">
                        <span class="material-icons" style="font-size: 12px; color: ${device.is_online ? 'var(--success-color)' : 'var(--text-hint)'};">fiber_manual_record</span>
                        ${device.is_online ? 'En línea' : 'Desconectado'}
                    </div>
                </div>
                
                <button class="btn" onclick="GroupsScreen.removeDeviceFromGroup('${device.id}')" style="padding: 8px; background: none; color: var(--error-color); border: 1px solid var(--error-color);" title="Remover del grupo">
                    <span class="material-icons" style="font-size: 16px;">remove</span>
                </button>
            </div>
        `;
    },

    renderAllDevices() {
        const ungroupedDevices = this.devices.filter(device => !device.group_id);
        
        if (ungroupedDevices.length === 0) return '';

        return `
            <div class="all-devices-section" style="margin: 16px;">
                <h3 style="color: var(--primary-purple); font-weight: 600; margin-bottom: 16px; font-family: 'Montserrat', sans-serif;">
                    <span class="material-icons" style="vertical-align: middle; margin-right: 8px;">devices_other</span>
                    Dispositivos Sin Grupo
                </h3>
                
                <div class="ungrouped-devices-list">
                    ${ungroupedDevices.map(device => this.renderUngroupedDevice(device)).join('')}
                </div>
            </div>
        `;
    },

    renderUngroupedDevice(device) {
        return `
            <div class="ungrouped-device" style="display: flex; align-items: center; gap: 16px; padding: 12px; background-color: var(--surface-color); border-radius: 8px; margin-bottom: 8px; border: 1px solid var(--divider-color);">
                <div class="device-icon" style="width: 40px; height: 40px; border-radius: 50%; background-color: var(--text-hint); display: flex; align-items: center; justify-content: center; color: white;">
                    <span class="material-icons" style="font-size: 20px;">${App.getDeviceIcon(device.device_type)}</span>
                </div>
                
                <div style="flex: 1;">
                    <div class="device-name" style="font-weight: 500; color: var(--text-primary);">${device.name}</div>
                    <div class="device-status" style="font-size: 14px; color: var(--text-secondary);">
                        <span class="material-icons" style="font-size: 12px; color: ${device.is_online ? 'var(--success-color)' : 'var(--text-hint)'};">fiber_manual_record</span>
                        ${device.is_online ? 'En línea' : 'Desconectado'}
                    </div>
                </div>
                
                <button class="btn btn-success" onclick="GroupsScreen.addSpecificDeviceToGroup('${device.id}')" style="padding: 8px 16px; background-color: var(--success-color); color: white; border: none;" title="Agregar a grupo seleccionado" ${!this.selectedGroup ? 'disabled' : ''}>
                    <span class="material-icons" style="font-size: 16px;">add</span>
                </button>
            </div>
        `;
    },

    renderActions() {
        return `
            <div class="groups-actions" style="margin: 16px; margin-top: 32px;">
                <div class="actions-grid" style="display: grid; gap: 12px;">
                    <button class="btn btn-primary" onclick="GroupsScreen.createGroup()">
                        <span class="material-icons">create_new_folder</span>
                        Crear Nuevo Grupo
                    </button>
                    
                    ${this.selectedGroup ? `
                        <button class="btn btn-secondary" onclick="GroupsScreen.sendGroupCommand()">
                            <span class="material-icons">send</span>
                            Enviar Comando al Grupo
                        </button>
                        
                        <button class="btn" onclick="GroupsScreen.deleteGroup('${this.selectedGroup.id}')" style="background-color: var(--error-color); color: white;">
                            <span class="material-icons">delete</span>
                            Eliminar Grupo
                        </button>
                    ` : ''}
                </div>
            </div>
        `;
    },

    renderError(errorMessage) {
        return `
            <div class="groups-container">
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

    getMockGroups() {
        return [
            {
                id: '1',
                name: 'Grupo 1',
                description: 'Dispositivos principales de seguridad',
                device_count: 2,
                created_at: '2024-01-15T10:00:00Z'
            },
            {
                id: '2', 
                name: 'Grupo 2',
                description: 'Accesos secundarios',
                device_count: 1,
                created_at: '2024-02-01T15:30:00Z'
            },
            {
                id: '3',
                name: 'Grupo 3', 
                description: 'Puertas internas',
                device_count: 0,
                created_at: '2024-02-15T09:20:00Z'
            }
        ];
    },

    // Initialize groups screen events after render
    init() {
        // Auto-select first group if none selected
        if (this.groups.length > 0 && !this.selectedGroup) {
            this.selectGroup(this.groups[0].id, false);
        }

        // Add hover effects for group cards
        const groupCards = document.querySelectorAll('.group-card:not(.selected)');
        groupCards.forEach(card => {
            card.addEventListener('mouseenter', () => {
                card.style.backgroundColor = 'rgba(123, 44, 191, 0.04)';
                card.style.transform = 'translateY(-1px)';
            });
            
            card.addEventListener('mouseleave', () => {
                card.style.backgroundColor = 'var(--surface-color)';
                card.style.transform = 'translateY(0)';
            });
        });
    },

    // Group management methods
    selectGroup(groupId, reRender = true) {
        this.selectedGroup = this.groups.find(g => g.id === groupId);
        
        if (reRender) {
            // Re-render the relevant sections
            this.updateGroupsSections();
        }
    },

    createGroup() {
        const name = prompt('Nombre del grupo:');
        if (!name) return;
        
        const description = prompt('Descripción (opcional):') || '';
        
        this.addNewGroup(name, description);
    },

    async addNewGroup(name, description) {
        try {
            App.showToast('Creando grupo...', 'info');
            
            // Mock API call - in real implementation: await API.createGroup({name, description})
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            const newGroup = {
                id: String(Date.now()),
                name,
                description,
                device_count: 0,
                created_at: new Date().toISOString()
            };
            
            this.groups.push(newGroup);
            this.updateGroupsSections();
            
            App.showToast('Grupo creado exitosamente', 'success');
            
        } catch (error) {
            console.error('Create group error:', error);
            App.showToast('Error creando grupo', 'error');
        }
    },

    editGroup(groupId) {
        const group = this.groups.find(g => g.id === groupId);
        if (!group) return;
        
        const newName = prompt('Nuevo nombre:', group.name);
        if (!newName) return;
        
        const newDescription = prompt('Nueva descripción:', group.description || '') || '';
        
        this.updateGroup(groupId, newName, newDescription);
    },

    async updateGroup(groupId, name, description) {
        try {
            App.showToast('Actualizando grupo...', 'info');
            
            // Mock API call
            await new Promise(resolve => setTimeout(resolve, 800));
            
            const group = this.groups.find(g => g.id === groupId);
            if (group) {
                group.name = name;
                group.description = description;
                this.updateGroupsSections();
                App.showToast('Grupo actualizado exitosamente', 'success');
            }
            
        } catch (error) {
            console.error('Update group error:', error);
            App.showToast('Error actualizando grupo', 'error');
        }
    },

    deleteGroup(groupId) {
        const group = this.groups.find(g => g.id === groupId);
        if (!group) return;
        
        if (confirm(`¿Estás seguro de que quieres eliminar el grupo "${group.name}"?\n\nLos dispositivos en el grupo volverán a estar sin agrupar.`)) {
            this.performDeleteGroup(groupId);
        }
    },

    async performDeleteGroup(groupId) {
        try {
            App.showToast('Eliminando grupo...', 'warning');
            
            // Mock API call
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            this.groups = this.groups.filter(g => g.id !== groupId);
            
            // Ungroup devices that were in this group
            this.devices.forEach(device => {
                if (device.group_id === groupId) {
                    device.group_id = null;
                }
            });
            
            // Clear selection if deleted group was selected
            if (this.selectedGroup?.id === groupId) {
                this.selectedGroup = null;
            }
            
            this.updateGroupsSections();
            App.showToast('Grupo eliminado exitosamente', 'success');
            
        } catch (error) {
            console.error('Delete group error:', error);
            App.showToast('Error eliminando grupo', 'error');
        }
    },

    addDeviceToGroup() {
        if (!this.selectedGroup) {
            App.showToast('Selecciona un grupo primero', 'warning');
            return;
        }
        
        // Show device selection dialog (simplified)
        const ungroupedDevices = this.devices.filter(d => !d.group_id);
        if (ungroupedDevices.length === 0) {
            App.showToast('No hay dispositivos disponibles para agregar', 'info');
            return;
        }
        
        const deviceNames = ungroupedDevices.map(d => d.name).join('\n');
        const selectedName = prompt(`Selecciona dispositivo para agregar a "${this.selectedGroup.name}":\n\n${deviceNames}\n\nEscribe el nombre exacto:`);
        
        const device = ungroupedDevices.find(d => d.name === selectedName);
        if (device) {
            this.addSpecificDeviceToGroup(device.id);
        } else if (selectedName) {
            App.showToast('Dispositivo no encontrado', 'error');
        }
    },

    async addSpecificDeviceToGroup(deviceId) {
        if (!this.selectedGroup) {
            App.showToast('Selecciona un grupo primero', 'warning');
            return;
        }
        
        try {
            App.showToast('Agregando dispositivo al grupo...', 'info');
            
            // Mock API call
            await new Promise(resolve => setTimeout(resolve, 800));
            
            const device = this.devices.find(d => d.id === deviceId);
            if (device) {
                device.group_id = this.selectedGroup.id;
                
                // Update group device count
                const group = this.groups.find(g => g.id === this.selectedGroup.id);
                if (group) {
                    group.device_count = (group.device_count || 0) + 1;
                }
                
                this.updateGroupsSections();
                App.showToast('Dispositivo agregado al grupo exitosamente', 'success');
            }
            
        } catch (error) {
            console.error('Add device to group error:', error);
            App.showToast('Error agregando dispositivo al grupo', 'error');
        }
    },

    async removeDeviceFromGroup(deviceId) {
        try {
            App.showToast('Removiendo dispositivo del grupo...', 'info');
            
            // Mock API call
            await new Promise(resolve => setTimeout(resolve, 800));
            
            const device = this.devices.find(d => d.id === deviceId);
            if (device && device.group_id === this.selectedGroup?.id) {
                device.group_id = null;
                
                // Update group device count
                const group = this.groups.find(g => g.id === this.selectedGroup.id);
                if (group) {
                    group.device_count = Math.max(0, (group.device_count || 0) - 1);
                }
                
                this.updateGroupsSections();
                App.showToast('Dispositivo removido del grupo', 'success');
            }
            
        } catch (error) {
            console.error('Remove device from group error:', error);
            App.showToast('Error removiendo dispositivo del grupo', 'error');
        }
    },

    sendGroupCommand() {
        if (!this.selectedGroup) return;
        
        const command = prompt(`Comando para enviar a todos los dispositivos en "${this.selectedGroup.name}":\n\nComandos disponibles: OPEN, CLOSE, STOP`);
        
        if (command && ['OPEN', 'CLOSE', 'STOP'].includes(command.toUpperCase())) {
            this.performGroupCommand(command.toUpperCase());
        } else if (command) {
            App.showToast('Comando no válido', 'error');
        }
    },

    async performGroupCommand(command) {
        try {
            App.showToast(`Enviando comando ${command} al grupo...`, 'info');
            
            // Mock API call
            await new Promise(resolve => setTimeout(resolve, 1500));
            
            App.showToast(`Comando ${command} enviado a todos los dispositivos del grupo`, 'success');
            
        } catch (error) {
            console.error('Group command error:', error);
            App.showToast('Error enviando comando al grupo', 'error');
        }
    },

    updateGroupsSections() {
        // Re-render the entire content
        const container = document.querySelector('.groups-container');
        if (container) {
            container.innerHTML = `
                ${this.renderHeader()}
                ${this.renderGroupsList()}
                ${this.renderSelectedGroupDevices()}
                ${this.renderAllDevices()}
                ${this.renderActions()}
            `;
            this.init();
        }
    },

    formatDate(dateString) {
        if (!dateString) return 'N/A';
        try {
            const date = new Date(dateString);
            return date.toLocaleDateString('es-ES', { day: 'numeric', month: 'short' });
        } catch {
            return 'N/A';
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
                        const groupsContainer = node.querySelector('.groups-container') || 
                                              (node.classList && node.classList.contains('groups-container') ? node : null);
                        if (groupsContainer) {
                            setTimeout(() => GroupsScreen.init(), 0);
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

window.GroupsScreen = GroupsScreen;