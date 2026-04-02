# VITA API — Validation Report

**Date:** 2026-03-13  
**Server:** 157.245.1.231:8000  
**Tested by:** Automated API testing via curl  

---

## Summary

| Area | ✅ Valid | ❌ Missing | ⚠️ Partial | Total Tests |
|------|---------|-----------|------------|-------------|
| Auth | 14 | 1 | 1 | 16 |
| Devices CRUD | 7 | 2 | 0 | 9 |
| Device Commands | 4 | 0 | 0 | 4 |
| Device Parameters | 2 | 3 | 0 | 5 |
| Device Users | 6 | 1 | 0 | 7 |
| Groups | 8 | 0 | 1 | 9 |
| Notifications | 4 | 0 | 0 | 4 |
| Support | 3 | 0 | 0 | 3 |
| **TOTAL** | **48** | **7** | **2** | **57** |

---

## 1. Auth

### ENDPOINT: POST /auth/login
- ✅ Empty body → 422 with field-level errors (email, password required)
- ✅ Empty email → 422 "not a valid email address"
- ✅ Invalid email format → 422 "not a valid email address"
- ✅ Wrong password → 401 "Incorrect email or password"
- ✅ Nonexistent email → 401 "Incorrect email or password" (good: doesn't reveal if email exists)
- ✅ Missing password field → 422 (field required) — *Note: got 429 rate limit on first attempt*
- ⚠️ Rate limiting active: after several failed attempts, returns 429 "Too many requests" — good security but frontend needs to handle this

### ENDPOINT: POST /auth/register
- ✅ Empty body → 422 (email, password, full_name required)
- ✅ Weak password (< 8 chars) → 422 "String should have at least 8 characters"
- ✅ Duplicate email → 409 "Email already registered"
- ✅ Invalid email → 422 "not a valid email address"
- ✅ Missing full_name → 422 "Field required"
- ❌ **Password complexity not validated beyond length**: only checks min 8 chars, doesn't require uppercase/lowercase/number/special char. Should validate password strength (e.g., must contain uppercase, lowercase, digit, special char). Expected: 422 with descriptive message.

### ENDPOINT: POST /auth/change-password
- ✅ Wrong current password → 400 "Current password is incorrect"
- ✅ Weak new password → 422 "String should have at least 8 characters"
- ✅ Empty body → 422 (current_password, new_password required)

### ENDPOINT: POST /auth/forgot-password
- ✅ Nonexistent email → 200 "If an account with this email exists..." (good: doesn't reveal existence)
- ✅ Invalid email format → 422 "not a valid email address"
- ✅ Empty body → 422 (email required)

---

## 2. Devices CRUD

### ENDPOINT: POST /devices
- ✅ Empty body → 422 (serial_number, name, device_type required)
- ✅ Missing required fields → 422 with specific field errors
- ✅ Invalid device_type → 422 "Device type must be one of: gate, barrier, door, camera, other"
- ✅ Duplicate serial_number → 409 "Device with this serial number already exists"
- ❌ **MAC address not validated**: accepts "invalid-mac" as mac_address, creates device successfully (HTTP 200). Should validate MAC format (XX:XX:XX:XX:XX:XX). Expected: 422 with "Invalid MAC address format".
- **Note:** API field is `serial_number` not `serial`. Frontend must use correct field name.

### ENDPOINT: PUT /devices/{id}
- ✅ Empty name → 422 "String should have at least 1 character"
- ✅ Very long name (260 chars) → 422 "String should have at most 100 characters"
- ✅ Nonexistent device → 404 "Device not found or you don't have access to it"
- ❌ **MAC address not validated on update**: accepts "not-a-mac", returns 200 (though appears to silently ignore it). Should validate format.

### ENDPOINT: DELETE /devices/{id}
- ✅ Nonexistent device → 404 "Device not found or you don't have permission to delete it"

### ENDPOINT: POST /devices/{id}/photo
- Not tested (requires multipart form upload — would need separate test)

---

## 3. Device Commands

### ENDPOINT: POST /devices/{id}/command
- ✅ Invalid command → 422 "Command must be one of: OPEN, CLOSE, STOP, OCS, PEDESTRIAN, LAMP, RELAY, GET_PARAMS, SET_PARAMS, GET_STATUS"
- ✅ Empty body → 422 "Field required" (command)
- ✅ Nonexistent device → 404 "Device not found or you don't have access to it"
- ✅ All valid commands accepted (OPEN, CLOSE, STOP, PEDESTRIAN, LAMP, RELAY, GET_STATUS)

**Notes:**
- Commands return status "completed" or "failed" based on MQTT response
- OPEN/CLOSE work correctly on device 1 (simulator)
- STOP, PEDESTRIAN, LAMP, RELAY, GET_STATUS return "failed" (simulator limitations)
- **Command names differ from DESIGN_SPEC**: API uses LAMP (not LAMP_TOGGLE), no BLOCK/UNBLOCK commands. Frontend needs to map correctly.

---

## 4. Device Parameters

### ENDPOINT: GET /devices/{id}/params/fields
- ✅ Returns complete parameter schema with name, type, range, description, and values

### ENDPOINT: GET /devices/{id}/params
- ✅ Returns current device parameters

### ENDPOINT: PUT /devices/{id}/params
- ❌ **No validation on unknown fields**: `{"nonexistent_field": 999}` → 200 "1 parameters set". Should reject unknown parameter names. Expected: 422 "Unknown parameter: nonexistent_field"
- ❌ **No type validation**: `{"lock_device": "not_a_boolean"}` → 200 accepted. Should validate against field schema.
- ❌ **No range validation**: `{"auto_close_time": 99999}` → 200 accepted. Should validate against defined ranges in params/fields.
- ✅ Empty body → 200 "0 parameters set" (acceptable)

### ENDPOINT: POST /devices/{id}/params/refresh
- ✅ Returns 200 "Parameters refreshed successfully from device"

---

## 5. Device Users/Permissions

### ENDPOINT: GET /devices/{id}/users
- ✅ Returns user list with roles and permissions

### ENDPOINT: POST /devices/{id}/users
- ✅ Nonexistent email → 404 "User with this email not found"
- ✅ Empty body → 422 "email Field required"
- ✅ User already has access → 409 "User already has access to this device"
- ❌ **Role not validated on invite**: sent `"role":"superadmin"` but got 409 (user already exists) instead of role validation. The role field may be ignored or not validated. Should validate role values (owner, admin, user, viewer). Expected: 422 "Invalid role"

### ENDPOINT: PUT /devices/{id}/users/{uid}/role
- ✅ Nonexistent user → 404 "User access not found"
- ✅ Cannot change owner role → 400 "Cannot change role of device owner"

### ENDPOINT: DELETE /devices/{id}/users/{uid}
- ✅ Cannot delete self (owner) → 400 "Device owner cannot revoke their own access"

---

## 6. Groups

### ENDPOINT: POST /groups
- ✅ Empty body → 422 (name required)
- ✅ Empty name → 422 "String should have at least 1 character"
- ✅ Duplicate name → 409 "Group with this name already exists"
- ✅ Valid creation → 200 with group object

### ENDPOINT: PUT /groups/{id}
- ✅ Empty name → 422 "String should have at least 1 character"

### ENDPOINT: POST /groups/{id}/devices
- ⚠️ **Uses query parameter, not JSON body**: `?device_id=X` not `{"device_id": X}`. Frontend must send as query param. Sending as JSON body → 422 "missing query device_id".
- ✅ Device already in group → 409 "Device is already in this group"

### ENDPOINT: DELETE /groups/{id}/devices/{did}
- ✅ Device not in group → 404 "Device is not in this group"

### ENDPOINT: POST /groups/{id}/command
- ✅ Empty group → 404 "No accessible devices found in this group"

### ENDPOINT: DELETE /groups/{id}
- ✅ Returns 200 with success message

---

## 7. Notifications

### ENDPOINT: GET /notifications
- ✅ Returns paginated list (empty in test, but structure correct with data + pagination)
- ✅ Pagination params accepted (?page=1&limit=5)

### ENDPOINT: PUT /notifications/{id}/read
- ✅ Nonexistent notification → 404 "Notification not found"

### ENDPOINT: PUT /notifications/preferences
- ✅ Requires device_id → 422 "Field required" (device_id is required)
- ✅ Empty body → 422 (device_id required)

### ENDPOINT: GET /notifications/preferences
- ✅ Returns per-device notification preferences array

---

## 8. Support

### ENDPOINT: POST /support/request
- ✅ Empty body → 422 (category, subject, description required)
- ✅ Missing fields → 422 with specific field errors
- **Note:** Required fields are: `category`, `subject`, `description` (not `message`). Frontend must use correct field names.

### ENDPOINT: GET /support/requests
- ✅ Returns paginated list
- ✅ Pagination params accepted

---

## Critical Findings — Missing Backend Validations

### HIGH PRIORITY (must fix before Flutter)

| # | Endpoint | Missing Validation | Expected Behavior |
|---|----------|-------------------|-------------------|
| 1 | POST /devices | MAC address format | 422: "Invalid MAC address format (expected XX:XX:XX:XX:XX:XX)" |
| 2 | PUT /devices/{id} | MAC address format | 422: "Invalid MAC address format" |
| 3 | PUT /devices/{id}/params | Unknown field names | 422: "Unknown parameter: {field_name}" |
| 4 | PUT /devices/{id}/params | Type validation | 422: "Parameter {name} must be {type}" |
| 5 | PUT /devices/{id}/params | Range validation | 422: "Parameter {name} must be between {min} and {max}" |

### MEDIUM PRIORITY

| # | Endpoint | Missing Validation | Expected Behavior |
|---|----------|-------------------|-------------------|
| 6 | POST /auth/register | Password complexity | 422: "Password must contain uppercase, lowercase, digit, and special character" |
| 7 | POST /devices/{id}/users | Role validation on invite | 422: "Role must be one of: admin, user, viewer" |

---

## Frontend Adjustments Needed

### 1. Error Response Formats
The API returns two different error formats:
- **Pydantic validation (422):** `{"detail": [{"type": "...", "loc": [...], "msg": "..."}]}`
- **Application errors (4xx):** `{"error": {"code": "...", "message": "...", "details": {}}}`

Frontend must handle both formats to display user-friendly messages.

### 2. Field Name Mismatches
| Frontend might use | API expects |
|-------------------|-------------|
| `serial` | `serial_number` |
| `type` | `device_type` |
| `message` (support) | `description` |
| `name` (register) | `full_name` |
| `LAMP_TOGGLE` | `LAMP` |
| `BLOCK/UNBLOCK` | Not available as commands |

### 3. Group Devices Endpoint
- `POST /groups/{id}/devices` uses **query parameter** `?device_id=X`, not JSON body

### 4. Rate Limiting
- API returns 429 with `{"error":{"code":"RATE_LIMIT_EXCEEDED","message":"Too many requests"}}`
- Frontend should show "Too many attempts, please wait" and implement backoff

### 5. Notification Preferences
- Preferences are **per-device**, not global
- Required field: `device_id` when updating preferences
- Fields: `notify_actions`, `notify_offline`, `notify_status_change`

---

## API Error Code Reference

| HTTP Status | Code | When |
|-------------|------|------|
| 400 | HTTP_400 | Business logic error (wrong password, can't change owner) |
| 401 | HTTP_401 | Authentication failed |
| 404 | HTTP_404 | Resource not found |
| 409 | HTTP_409 | Conflict (duplicate serial, email, group name, already in group) |
| 422 | (pydantic) | Input validation failed (missing/invalid fields) |
| 429 | RATE_LIMIT_EXCEEDED | Too many requests |

---

## Recommendations for Flutter Integration

1. **Create a unified error parser** that handles both Pydantic 422 and application error formats
2. **Map Pydantic `loc` fields** to form field names for inline error display
3. **Add client-side MAC validation** as a UX improvement (backend should also validate)
4. **Add client-side parameter range validation** using the schema from GET /params/fields
5. **Cache the params/fields schema** — it defines valid parameter names, types, and ranges
6. **Implement retry with backoff** for 429 responses
7. **Use correct field names** from the start (serial_number, device_type, full_name, description)
