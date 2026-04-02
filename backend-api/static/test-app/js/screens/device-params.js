const DeviceParamsScreen = {
    deviceId: null,
    fields: [],
    values: {},

    async render(deviceId) {
        this.deviceId = deviceId;
        if (!deviceId) return '<div class="error">ID no proporcionado</div>';

        try {
            const [fieldsRes, valuesRes] = await Promise.all([
                API.getParamFields(deviceId),
                API.getDeviceParams(deviceId)
            ]);

            this.fields = fieldsRes.success ? (fieldsRes.data.data || fieldsRes.data || []) : [];
            this.values = valuesRes.success ? (valuesRes.data.data || valuesRes.data || {}) : {};

            const empty = this.fields.length === 0;

            return '<div class="params-container">' +
                '<div class="header">' +
                    '<button class="header-back material-icons" onclick="App.navigate(\'#/devices/' + deviceId + '\')">arrow_back</button>' +
                    '<h1 class="header-title">Parámetros</h1>' +
                    '<img src="images/IconoLogo_transparente.png" class="header-logo" alt="BGnius">' +
                '</div>' +
                '<div class="params-toolbar">' +
                    '<button class="btn-pill btn-pill-outline" onclick="DeviceParamsScreen.refresh()">' +
                        '<span class="material-icons">refresh</span> Refrescar' +
                    '</button>' +
                '</div>' +
                '<form id="params-form" class="edit-form" onsubmit="event.preventDefault(); DeviceParamsScreen.save()">' +
                    (empty
                        ? '<div class="text-center" style="padding:48px 0;color:var(--text-hint)"><span class="material-icons" style="font-size:48px">settings</span><p style="margin-top:8px">Sin parámetros configurables</p></div>'
                        : '<div class="edit-section">' + this.fields.map(function(f) { return DeviceParamsScreen.renderField(f); }).join('') + '</div>') +
                    (empty ? '' : '<button type="submit" class="edit-btn edit-btn-save" id="params-save-btn" style="margin-top:8px"><span class="material-icons">save</span> Guardar cambios</button>') +
                '</form>' +
            '</div>';
        } catch (e) {
            console.error(e);
            return '<div class="error">Error cargando parámetros</div>';
        }
    },

    renderField(field) {
        var name = field.name || field.key;
        var label = field.label || name;
        var type = field.type || 'text';
        var value = this.values[name] !== undefined ? this.values[name] : (field.default || '');
        var desc = field.description || '';

        if (type === 'boolean' || type === 'bool') {
            var checked = value === true || value === 'true' || value === 1;
            return '<div class="edit-field">' +
                '<div class="param-toggle-row">' +
                    '<div><span class="edit-label" style="margin-bottom:0">' + label + '</span>' +
                    (desc ? '<span class="param-desc">' + desc + '</span>' : '') + '</div>' +
                    '<label class="toggle-switch"><input type="checkbox" name="' + name + '"' + (checked ? ' checked' : '') + '><span class="toggle-slider"></span></label>' +
                '</div></div>';
        }

        if (type === 'select' || type === 'enum') {
            var options = field.options || field.choices || [];
            var optHtml = options.map(function(o) {
                var v = typeof o === 'object' ? o.value : o;
                var l = typeof o === 'object' ? (o.label || o.value) : o;
                return '<option value="' + v + '"' + (v == value ? ' selected' : '') + '>' + l + '</option>';
            }).join('');
            return '<div class="edit-field">' +
                '<label class="edit-label">' + label + '</label>' +
                (desc ? '<span class="param-desc">' + desc + '</span>' : '') +
                '<div class="edit-input-wrap"><span class="material-icons edit-input-icon">list</span>' +
                '<select name="' + name + '" class="edit-input edit-select">' + optHtml + '</select></div></div>';
        }

        var inputType = type === 'number' ? 'number' : 'text';
        var icon = type === 'number' ? 'pin' : 'text_fields';
        return '<div class="edit-field">' +
            '<label class="edit-label">' + label + '</label>' +
            (desc ? '<span class="param-desc">' + desc + '</span>' : '') +
            '<div class="edit-input-wrap"><span class="material-icons edit-input-icon">' + icon + '</span>' +
            '<input type="' + inputType + '" name="' + name + '" value="' + value + '" class="edit-input"' +
            (field.min !== undefined ? ' min="' + field.min + '"' : '') +
            (field.max !== undefined ? ' max="' + field.max + '"' : '') + '></div></div>';
    },

    async save() {
        var form = document.getElementById('params-form');
        var btn = document.getElementById('params-save-btn');
        if (!form) return;

        var params = {};
        this.fields.forEach(function(f) {
            var name = f.name || f.key;
            var type = f.type || 'text';
            var el = form.querySelector('[name="' + name + '"]');
            if (!el) return;
            if (type === 'boolean' || type === 'bool') params[name] = el.checked;
            else if (type === 'number') params[name] = Number(el.value);
            else params[name] = el.value;
        });

        if (btn) { btn.disabled = true; btn.innerHTML = '<div class="spinner" style="width:20px;height:20px;border-width:2px"></div> Guardando...'; }
        var res = await API.setDeviceParams(this.deviceId, params);
        if (res.success) App.showToast('Parámetros guardados', 'success');
        else App.showToast('Error: ' + (res.error || 'desconocido'), 'error');
        if (btn) { btn.disabled = false; btn.innerHTML = '<span class="material-icons">save</span> Guardar cambios'; }
    },

    async refresh() {
        App.showToast('Refrescando desde dispositivo...', 'info');
        var res = await API.refreshParams(this.deviceId);
        if (res.success) {
            App.showToast('Valores actualizados', 'success');
            App.currentScreen = null;
            App.loadScreen('device-params', { deviceId: this.deviceId });
        } else {
            App.showToast('Error: ' + (res.error || 'desconocido'), 'error');
        }
    },

    init() {}
};
window.DeviceParamsScreen = DeviceParamsScreen;
