// VITA API Client Module
const API = {
    baseUrl: 'http://157.245.1.231:8000/api/v1',
    token: localStorage.getItem('vita_token') || null,

    // Helper method to make authenticated requests
    async request(endpoint, options = {}) {
        const url = `${this.baseUrl}${endpoint}`;
        const config = {
            headers: {
                'Content-Type': 'application/json',
                ...options.headers
            },
            ...options
        };

        // Add authorization header if token exists
        if (this.token && !config.headers.Authorization) {
            config.headers.Authorization = `Bearer ${this.token}`;
        }

        try {
            const response = await fetch(url, config);
            
            // Check if response is JSON
            const contentType = response.headers.get('content-type');
            let data;
            
            if (contentType && contentType.includes('application/json')) {
                data = await response.json();
            } else {
                data = { message: await response.text() };
            }

            if (!response.ok) {
                throw new Error(data.detail || data.message || `HTTP ${response.status}`);
            }

            return {
                success: true,
                data,
                status: response.status
            };
        } catch (error) {
            console.error(`API Request failed for ${endpoint}:`, error);
            return {
                success: false,
                error: error.message,
                status: 0
            };
        }
    },

    // Authentication
    async login(email, password) {
        const result = await this.request('/auth/login', {
            method: 'POST',
            body: JSON.stringify({
                email,
                password
            })
        });

        if (result.success && result.data.access_token) {
            this.token = result.data.access_token;
            localStorage.setItem('vita_token', this.token);
        }

        return result;
    },

    logout() {
        this.token = null;
        localStorage.removeItem('vita_token');
    },

    isAuthenticated() {
        return !!this.token;
    },

    // Device operations
    async getDevices() {
        return await this.request('/devices');
    },

    async getDeviceDetail(deviceId) {
        return await this.request(`/devices/${deviceId}/full`);
    },

    async getDeviceActions(deviceId) {
        return await this.request(`/devices/${deviceId}/actions`);
    },

    async sendCommand(deviceId, command) {
        return await this.request(`/devices/${deviceId}/command`, {
            method: 'POST',
            body: JSON.stringify({
                command
            })
        });
    },

    // Device parameters (for future phases)
    async getDeviceParams(deviceId) {
        return await this.request(`/devices/${deviceId}/params`);
    },

    async updateDeviceParams(deviceId, params) {
        return await this.request(`/devices/${deviceId}/params`, {
            method: 'PUT',
            body: JSON.stringify(params)
        });
    },

    async refreshDeviceParams(deviceId) {
        return await this.request(`/devices/${deviceId}/params/refresh`, {
            method: 'POST'
        });
    },

    // Device management (for future phases)
    async updateDevice(deviceId, updates) {
        return await this.request(`/devices/${deviceId}`, {
            method: 'PUT',
            body: JSON.stringify(updates)
        });
    },

    async createDevice(deviceData) {
        return await this.request('/devices', {
            method: 'POST',
            body: JSON.stringify(deviceData)
        });
    },

    async deleteDevice(deviceId) {
        return await this.request(`/devices/${deviceId}`, {
            method: 'DELETE'
        });
    },

    async deleteDevicePhoto(deviceId) {
        return await this.request(`/devices/${deviceId}/photo`, {
            method: 'DELETE'
        });
    },

    // Device Parameters
    async getDeviceParamFields(deviceId) {
        return await this.request(`/devices/${deviceId}/params/fields`);
    },

    // Device Users
    async addUserToDevice(deviceId, userData) {
        return await this.request(`/devices/${deviceId}/users`, {
            method: 'POST',
            body: JSON.stringify(userData)
        });
    },

    async removeUserFromDevice(deviceId, userId) {
        return await this.request(`/devices/${deviceId}/users/${userId}`, {
            method: 'DELETE'
        });
    },

    async updateDeviceUserRole(deviceId, userId, role) {
        return await this.request(`/devices/${deviceId}/users/${userId}/role`, {
            method: 'PUT',
            body: JSON.stringify({ role })
        });
    },

    // Device Advanced
    async getDeviceAdvancedActions(deviceId) {
        return await this.request(`/devices/${deviceId}/advanced/actions`);
    },

    async getDeviceAdvancedMaintenance(deviceId) {
        return await this.request(`/devices/${deviceId}/advanced/maintenance`);
    },

    async resetDeviceMaintenance(deviceId) {
        return await this.request(`/devices/${deviceId}/advanced/maintenance/reset`, {
            method: 'POST'
        });
    },

    async executeAdvancedAction(deviceId, action, data = {}) {
        return await this.request(`/devices/${deviceId}/advanced/${action}`, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },

    // Installer Sessions
    async getInstallerSessionStatus(deviceId) {
        return await this.request(`/devices/${deviceId}/session/status`);
    },

    async startInstallerSession(deviceId) {
        return await this.request(`/devices/${deviceId}/session/start`, {
            method: 'POST'
        });
    },

    async closeInstallerSession(deviceId) {
        return await this.request(`/devices/${deviceId}/session/close`, {
            method: 'POST'
        });
    },

    async extendInstallerSession(deviceId) {
        return await this.request(`/devices/${deviceId}/session/extend`, {
            method: 'POST'
        });
    },

    // Learn Controls
    async getLearnActions(deviceId) {
        return await this.request(`/devices/${deviceId}/learn/actions`);
    },

    async executeLearnAction(deviceId, action) {
        return await this.request(`/devices/${deviceId}/learn/${action}`, {
            method: 'POST'
        });
    },

    async executeLearnSequence(deviceId, sequenceData) {
        return await this.request(`/devices/${deviceId}/learn/sequence`, {
            method: 'POST',
            body: JSON.stringify(sequenceData)
        });
    },

    // Photocells
    async getPhotocellStatus(deviceId) {
        return await this.request(`/devices/${deviceId}/photocell/status`);
    },

    async getPhotocellActions(deviceId) {
        return await this.request(`/devices/${deviceId}/photocell/actions`);
    },

    async executePhotocellAction(deviceId, action) {
        return await this.request(`/devices/${deviceId}/photocell/${action}`, {
            method: 'POST'
        });
    },

    async executePhotocellSequence(deviceId, sequenceData) {
        return await this.request(`/devices/${deviceId}/photocell/sequence`, {
            method: 'POST',
            body: JSON.stringify(sequenceData)
        });
    },

    // Groups (for future phases)
    async getGroups() {
        return await this.request('/groups');
    },

    // Device users (for future phases)
    async getDeviceUsers(deviceId) {
        return await this.request(`/devices/${deviceId}/users`);
    },

    // Events (for future phases)
    async getDeviceEvents(deviceId, limit = 50) {
        return await this.request(`/devices/${deviceId}/events?limit=${limit}`);
    },

    // Notifications
    async getNotifications() {
        return await this.request('/notifications');
    },

    async getUnreadNotificationsCount() {
        return await this.request('/notifications/unread-count');
    },

    async markNotificationRead(notificationId) {
        return await this.request(`/notifications/${notificationId}/read`, {
            method: 'PUT'
        });
    },

    async markAllNotificationsRead() {
        return await this.request('/notifications/read-all', {
            method: 'PUT'
        });
    },

    async getNotificationPreferences() {
        return await this.request('/notifications/preferences');
    },

    async updateNotificationPreferences(preferences) {
        return await this.request('/notifications/preferences', {
            method: 'PUT',
            body: JSON.stringify(preferences)
        });
    },

    // Support
    async getDeviceSupport(deviceId) {
        return await this.request(`/devices/${deviceId}/support`);
    },

    async getSupportContacts() {
        return await this.request('/support/contacts');
    },

    async getSupportRequests() {
        return await this.request('/support/requests');
    },

    async getSupportRequest(requestId) {
        return await this.request(`/support/requests/${requestId}`);
    },

    async createSupportRequest(requestData) {
        return await this.request('/support/request', {
            method: 'POST',
            body: JSON.stringify(requestData)
        });
    },

    // Advanced config (for future phases)
    async advancedDeviceAction(deviceId, action, data = {}) {
        return await this.request(`/devices/${deviceId}/advanced/${action}`, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },

    // User management
    async register(userData) {
        return await this.request('/auth/register', {
            method: 'POST',
            body: JSON.stringify(userData)
        });
    },

    async requestPasswordReset(email) {
        return await this.request('/auth/reset-password', {
            method: 'POST',
            body: JSON.stringify({ email })
        });
    },

    // User management
    async getUsers() {
        return await this.request('/users');
    },

    async getCurrentUser() {
        return await this.request('/users/me');
    },

    async updateCurrentUser(userData) {
        return await this.request('/users/me', {
            method: 'PUT',
            body: JSON.stringify(userData)
        });
    },

    async getUser(userId) {
        return await this.request(`/users/${userId}`);
    },

    async changePassword(currentPassword, newPassword) {
        return await this.request('/users/me/change-password', {
            method: 'POST',
            body: JSON.stringify({
                current_password: currentPassword,
                new_password: newPassword
            })
        });
    },

    async uploadUserPhoto(file) {
        const formData = new FormData();
        formData.append('photo', file);
        
        return await this.request('/users/me/photo', {
            method: 'POST',
            body: formData,
            headers: {
                'Authorization': `Bearer ${this.token}`
            }
        });
    },

    async deleteUserPhoto() {
        return await this.request('/users/me/photo', {
            method: 'DELETE'
        });
    },

    // Device management
    async uploadDevicePhoto(deviceId, file) {
        const formData = new FormData();
        formData.append('photo', file);
        
        return await this.request(`/devices/${deviceId}/photo`, {
            method: 'POST',
            body: formData,
            headers: {
                // Don't set Content-Type for FormData, let browser set it
                'Authorization': `Bearer ${this.token}`
            }
        });
    },

    // Group management
    async createGroup(groupData) {
        return await this.request('/groups', {
            method: 'POST',
            body: JSON.stringify(groupData)
        });
    },

    async updateGroup(groupId, groupData) {
        return await this.request(`/groups/${groupId}`, {
            method: 'PUT',
            body: JSON.stringify(groupData)
        });
    },

    async deleteGroup(groupId) {
        return await this.request(`/groups/${groupId}`, {
            method: 'DELETE'
        });
    },

    async addDeviceToGroup(groupId, deviceId) {
        return await this.request(`/groups/${groupId}/devices`, {
            method: 'POST',
            body: JSON.stringify({ device_id: deviceId })
        });
    },

    async removeDeviceFromGroup(groupId, deviceId) {
        return await this.request(`/groups/${groupId}/devices/${deviceId}`, {
            method: 'DELETE'
        });
    },

    async sendGroupCommand(groupId, command) {
        return await this.request(`/groups/${groupId}/command`, {
            method: 'POST',
            body: JSON.stringify({ command })
        });
    },

    async getGroup(groupId) {
        return await this.request(`/groups/${groupId}`);
    },

    // Action Templates
    async getActionTemplates() {
        return await this.request('/action-templates');
    },

    async createActionTemplate(templateData) {
        return await this.request('/action-templates', {
            method: 'POST',
            body: JSON.stringify(templateData)
        });
    },

    async updateActionTemplate(templateId, templateData) {
        return await this.request(`/action-templates/${templateId}`, {
            method: 'PUT',
            body: JSON.stringify(templateData)
        });
    },

    async deleteActionTemplate(templateId) {
        return await this.request(`/action-templates/${templateId}`, {
            method: 'DELETE'
        });
    },

    // Action Overrides
    async getDeviceActionOverrides(deviceId) {
        return await this.request(`/devices/${deviceId}/action-overrides`);
    },

    async updateDeviceActionOverrides(deviceId, overrides) {
        return await this.request(`/devices/${deviceId}/action-overrides`, {
            method: 'PUT',
            body: JSON.stringify(overrides)
        });
    },

    // Refresh token
    async refreshToken() {
        return await this.request('/auth/refresh', {
            method: 'POST'
        });
    },

    // Get current user info
    async getCurrentUserInfo() {
        return await this.request('/auth/me');
    }
};

// Export for use in other modules
window.API = API;