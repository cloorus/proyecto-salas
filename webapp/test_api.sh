#!/bin/bash
# VITA API Validation Test Script
# Runs all endpoint tests and outputs structured results

BASE="http://localhost:8000/api/v1"
REPORT=""

# Helper: make request, capture status + body
req() {
  local method="$1" path="$2" data="$3" extra="$4"
  local url="${BASE}${path}"
  if [ -n "$data" ]; then
    result=$(curl -s -w "\n---HTTP_STATUS:%{http_code}---" -X "$method" "$url" -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" $extra -d "$data" 2>&1)
  else
    result=$(curl -s -w "\n---HTTP_STATUS:%{http_code}---" -X "$method" "$url" -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" $extra 2>&1)
  fi
  BODY=$(echo "$result" | sed 's/---HTTP_STATUS:[0-9]*---$//')
  STATUS=$(echo "$result" | grep -o 'HTTP_STATUS:[0-9]*' | cut -d: -f2)
  echo "  STATUS: $STATUS"
  echo "  BODY: $BODY" | head -3
}

# Get fresh token
echo "=== Getting token ==="
login_result=$(curl -s -X POST "$BASE/auth/login" -H "Content-Type: application/json" -d '{"email":"admin@bgnius.com","password":"Test1234!"}')
TOKEN=$(echo "$login_result" | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")
echo "Token obtained: ${TOKEN:0:20}..."

echo ""
echo "=========================================="
echo "1. AUTH TESTS"
echo "=========================================="

echo ""
echo "--- POST /auth/login: empty body ---"
req POST /auth/login '{}'

echo ""
echo "--- POST /auth/login: empty email ---"
req POST /auth/login '{"email":"","password":"Test1234!"}'

echo ""
echo "--- POST /auth/login: invalid email format ---"
req POST /auth/login '{"email":"notanemail","password":"Test1234!"}'

echo ""
echo "--- POST /auth/login: wrong password ---"
req POST /auth/login '{"email":"admin@bgnius.com","password":"wrongpassword"}'

echo ""
echo "--- POST /auth/login: nonexistent email ---"
req POST /auth/login '{"email":"noexiste@test.com","password":"Test1234!"}'

echo ""
echo "--- POST /auth/login: missing password field ---"
req POST /auth/login '{"email":"admin@bgnius.com"}'

echo ""
echo "--- POST /auth/register: empty body ---"
req POST /auth/register '{}'

echo ""
echo "--- POST /auth/register: weak password ---"
req POST /auth/register '{"email":"test_weak@test.com","password":"123","name":"Test"}'

echo ""
echo "--- POST /auth/register: duplicate email ---"
req POST /auth/register '{"email":"admin@bgnius.com","password":"Test1234!","name":"Duplicate"}'

echo ""
echo "--- POST /auth/register: invalid email format ---"
req POST /auth/register '{"email":"bademail","password":"Test1234!","name":"Bad"}'

echo ""
echo "--- POST /auth/register: missing name ---"
req POST /auth/register '{"email":"test_noname@test.com","password":"Test1234!"}'

echo ""
echo "--- POST /auth/change-password: wrong current password ---"
req POST /auth/change-password '{"current_password":"wrongpass","new_password":"NewPass123!"}'

echo ""
echo "--- POST /auth/change-password: weak new password ---"
req POST /auth/change-password '{"current_password":"Test1234!","new_password":"123"}'

echo ""
echo "--- POST /auth/change-password: empty body ---"
req POST /auth/change-password '{}'

echo ""
echo "--- POST /auth/forgot-password: nonexistent email ---"
req POST /auth/forgot-password '{"email":"noexiste@nowhere.com"}'

echo ""
echo "--- POST /auth/forgot-password: invalid email ---"
req POST /auth/forgot-password '{"email":"notvalid"}'

echo ""
echo "--- POST /auth/forgot-password: empty ---"
req POST /auth/forgot-password '{}'

echo ""
echo "=========================================="
echo "2. DEVICES CRUD TESTS"
echo "=========================================="

echo ""
echo "--- GET /devices (list, to get a device ID) ---"
req GET /devices

echo ""
echo "--- POST /devices: empty body ---"
req POST /devices '{}'

echo ""
echo "--- POST /devices: missing required fields ---"
req POST /devices '{"name":"TestOnly"}'

echo ""
echo "--- POST /devices: invalid MAC ---"
req POST /devices '{"name":"Test","serial":"TEST001","mac_address":"invalid-mac","device_type":"gate"}'

echo ""
echo "--- POST /devices: invalid device_type ---"
req POST /devices '{"name":"Test","serial":"TEST002","mac_address":"AA:BB:CC:DD:EE:FF","device_type":"invalid_type"}'

echo ""
echo "--- POST /devices: valid device (for later tests) ---"
req POST /devices '{"name":"TestDevice","serial":"TESTSERIAL001","mac_address":"AA:BB:CC:DD:EE:01","device_type":"gate"}'
# Capture test device ID
TEST_DEVICE_ID=$(echo "$BODY" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('id',d.get('data',{}).get('id','')))" 2>/dev/null || echo "")
echo "  TEST_DEVICE_ID: $TEST_DEVICE_ID"

echo ""
echo "--- POST /devices: duplicate serial ---"
req POST /devices '{"name":"TestDevice2","serial":"TESTSERIAL001","mac_address":"AA:BB:CC:DD:EE:02","device_type":"gate"}'

echo ""
echo "--- PUT /devices/99999: nonexistent device ---"
req PUT /devices/99999 '{"name":"Updated"}'

if [ -n "$TEST_DEVICE_ID" ] && [ "$TEST_DEVICE_ID" != "" ]; then
  echo ""
  echo "--- PUT /devices/$TEST_DEVICE_ID: empty name ---"
  req PUT "/devices/$TEST_DEVICE_ID" '{"name":""}'

  echo ""
  echo "--- PUT /devices/$TEST_DEVICE_ID: very long name ---"
  req PUT "/devices/$TEST_DEVICE_ID" '{"name":"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"}'

  echo ""
  echo "--- PUT /devices/$TEST_DEVICE_ID: invalid MAC ---"
  req PUT "/devices/$TEST_DEVICE_ID" '{"mac_address":"not-a-mac"}'

  echo ""
  echo "--- PUT /devices/$TEST_DEVICE_ID: invalid serial ---"
  req PUT "/devices/$TEST_DEVICE_ID" '{"serial":""}'
fi

echo ""
echo "--- DELETE /devices/99999: nonexistent ---"
req DELETE /devices/99999

echo ""
echo "=========================================="
echo "3. DEVICE COMMANDS TESTS"
echo "=========================================="

# Get first real device
REAL_DEVICE=$(curl -s "$BASE/devices" -H "Authorization: Bearer $TOKEN" | python3 -c "import sys,json; d=json.load(sys.stdin); items=d.get('data',d) if isinstance(d.get('data',d),list) else d.get('data',{}).get('data',[]); print(items[0]['id'] if items else '')" 2>/dev/null)
echo "Using device ID: $REAL_DEVICE"

if [ -n "$REAL_DEVICE" ]; then
  echo ""
  echo "--- POST /devices/$REAL_DEVICE/command: invalid command ---"
  req POST "/devices/$REAL_DEVICE/command" '{"command":"INVALID_CMD"}'

  echo ""
  echo "--- POST /devices/$REAL_DEVICE/command: empty body ---"
  req POST "/devices/$REAL_DEVICE/command" '{}'

  for cmd in OPEN CLOSE STOP PEDESTRIAN BLOCK UNBLOCK LAMP_TOGGLE RELAY STATUS; do
    echo ""
    echo "--- POST /devices/$REAL_DEVICE/command: $cmd ---"
    req POST "/devices/$REAL_DEVICE/command" "{\"command\":\"$cmd\"}"
  done
fi

echo ""
echo "--- POST /devices/99999/command: nonexistent device ---"
req POST /devices/99999/command '{"command":"OPEN"}'

echo ""
echo "=========================================="
echo "4. DEVICE PARAMETERS TESTS"
echo "=========================================="

if [ -n "$REAL_DEVICE" ]; then
  echo ""
  echo "--- GET /devices/$REAL_DEVICE/params/fields ---"
  req GET "/devices/$REAL_DEVICE/params/fields"

  echo ""
  echo "--- GET /devices/$REAL_DEVICE/params ---"
  req GET "/devices/$REAL_DEVICE/params"

  echo ""
  echo "--- PUT /devices/$REAL_DEVICE/params: invalid field ---"
  req PUT "/devices/$REAL_DEVICE/params" '{"nonexistent_field": 999}'

  echo ""
  echo "--- PUT /devices/$REAL_DEVICE/params: wrong type ---"
  req PUT "/devices/$REAL_DEVICE/params" '{"lock_device": "not_a_boolean"}'

  echo ""
  echo "--- PUT /devices/$REAL_DEVICE/params: out of range ---"
  req PUT "/devices/$REAL_DEVICE/params" '{"auto_close_time": 99999}'

  echo ""
  echo "--- PUT /devices/$REAL_DEVICE/params: empty body ---"
  req PUT "/devices/$REAL_DEVICE/params" '{}'

  echo ""
  echo "--- POST /devices/$REAL_DEVICE/params/refresh ---"
  req POST "/devices/$REAL_DEVICE/params/refresh" '{}'
fi

echo ""
echo "=========================================="
echo "5. DEVICE USERS/PERMISSIONS TESTS"
echo "=========================================="

if [ -n "$REAL_DEVICE" ]; then
  echo ""
  echo "--- GET /devices/$REAL_DEVICE/users ---"
  req GET "/devices/$REAL_DEVICE/users"

  echo ""
  echo "--- POST /devices/$REAL_DEVICE/users: nonexistent email ---"
  req POST "/devices/$REAL_DEVICE/users" '{"email":"noexiste@nowhere.com"}'

  echo ""
  echo "--- POST /devices/$REAL_DEVICE/users: invalid role ---"
  req POST "/devices/$REAL_DEVICE/users" '{"email":"admin@bgnius.com","role":"superadmin"}'

  echo ""
  echo "--- POST /devices/$REAL_DEVICE/users: empty body ---"
  req POST "/devices/$REAL_DEVICE/users" '{}'

  echo ""
  echo "--- PUT /devices/$REAL_DEVICE/users/99999/role: nonexistent user ---"
  req PUT "/devices/$REAL_DEVICE/users/99999/role" '{"role":"admin"}'

  echo ""
  echo "--- PUT /devices/$REAL_DEVICE/users/1/role: invalid role ---"
  req PUT "/devices/$REAL_DEVICE/users/1/role" '{"role":"invalid_role"}'

  echo ""
  echo "--- DELETE /devices/$REAL_DEVICE/users/1: try delete self (owner) ---"
  req DELETE "/devices/$REAL_DEVICE/users/1"
fi

echo ""
echo "=========================================="
echo "6. GROUPS TESTS"
echo "=========================================="

echo ""
echo "--- POST /groups: empty body ---"
req POST /groups '{}'

echo ""
echo "--- POST /groups: empty name ---"
req POST /groups '{"name":""}'

echo ""
echo "--- POST /groups: valid group (for later tests) ---"
req POST /groups '{"name":"TestGroup_API"}'
TEST_GROUP_ID=$(echo "$BODY" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('id',d.get('data',{}).get('id','')))" 2>/dev/null || echo "")
echo "  TEST_GROUP_ID: $TEST_GROUP_ID"

echo ""
echo "--- POST /groups: duplicate name ---"
req POST /groups '{"name":"TestGroup_API"}'

echo ""
echo "--- GET /groups ---"
req GET /groups

if [ -n "$TEST_GROUP_ID" ]; then
  echo ""
  echo "--- PUT /groups/$TEST_GROUP_ID: empty name ---"
  req PUT "/groups/$TEST_GROUP_ID" '{"name":""}'

  echo ""
  echo "--- POST /groups/$TEST_GROUP_ID/devices: nonexistent device ---"
  req POST "/groups/$TEST_GROUP_ID/devices" '{"device_id":99999}'

  if [ -n "$REAL_DEVICE" ]; then
    echo ""
    echo "--- POST /groups/$TEST_GROUP_ID/devices: valid device ---"
    req POST "/groups/$TEST_GROUP_ID/devices" "{\"device_id\":$REAL_DEVICE}"

    echo ""
    echo "--- POST /groups/$TEST_GROUP_ID/devices: device already in group ---"
    req POST "/groups/$TEST_GROUP_ID/devices" "{\"device_id\":$REAL_DEVICE}"

    echo ""
    echo "--- DELETE /groups/$TEST_GROUP_ID/devices/$REAL_DEVICE ---"
    req DELETE "/groups/$TEST_GROUP_ID/devices/$REAL_DEVICE"

    echo ""
    echo "--- DELETE /groups/$TEST_GROUP_ID/devices/$REAL_DEVICE: device not in group ---"
    req DELETE "/groups/$TEST_GROUP_ID/devices/$REAL_DEVICE"
  fi

  echo ""
  echo "--- POST /groups/$TEST_GROUP_ID/command: command to empty group ---"
  req POST "/groups/$TEST_GROUP_ID/command" '{"command":"OPEN"}'
fi

echo ""
echo "=========================================="
echo "7. NOTIFICATIONS TESTS"
echo "=========================================="

echo ""
echo "--- GET /notifications ---"
req GET /notifications

echo ""
echo "--- GET /notifications?page=1&limit=5 ---"
req GET "/notifications?page=1&limit=5"

echo ""
echo "--- PUT /notifications/99999/read: nonexistent ---"
req PUT /notifications/99999/read '{}'

echo ""
echo "--- GET /notifications/preferences ---"
req GET /notifications/preferences

echo ""
echo "--- PUT /notifications/preferences: invalid values ---"
req PUT /notifications/preferences '{"push_enabled":"not_bool","email_enabled":999}'

echo ""
echo "--- PUT /notifications/preferences: empty ---"
req PUT /notifications/preferences '{}'

echo ""
echo "=========================================="
echo "8. SUPPORT TESTS"
echo "=========================================="

echo ""
echo "--- POST /support/request: empty body ---"
req POST /support/request '{}'

echo ""
echo "--- POST /support/request: missing subject ---"
req POST /support/request '{"message":"test message"}'

echo ""
echo "--- POST /support/request: very long subject ---"
LONG_SUBJ=$(python3 -c "print('A'*500)")
req POST /support/request "{\"subject\":\"$LONG_SUBJ\",\"message\":\"test\"}"

echo ""
echo "--- POST /support/request: invalid device_id ---"
req POST /support/request '{"subject":"Test","message":"test","device_id":99999}'

echo ""
echo "--- GET /support/requests ---"
req GET /support/requests

echo ""
echo "--- GET /support/requests?page=1&limit=5 ---"
req GET "/support/requests?page=1&limit=5"

echo ""
echo "=========================================="
echo "CLEANUP"
echo "=========================================="

if [ -n "$TEST_GROUP_ID" ]; then
  echo ""
  echo "--- DELETE /groups/$TEST_GROUP_ID ---"
  req DELETE "/groups/$TEST_GROUP_ID"
fi

if [ -n "$TEST_DEVICE_ID" ]; then
  echo ""
  echo "--- DELETE /devices/$TEST_DEVICE_ID ---"
  req DELETE "/devices/$TEST_DEVICE_ID"
fi

echo ""
echo "=========================================="
echo "DONE - All tests completed"
echo "=========================================="
