#!/bin/bash
# deploy.sh - Deploy proyecto-salas to production server
# Usage: ./deploy.sh "commit message" [backend|webapp|admin|all]

set -e

SERVER="root@157.245.1.231"
REMOTE_PATH="/opt/projects/proyecto-salas"

if [ -z "$1" ]; then
    echo "❌ Error: Commit message required"
    echo "Usage: ./deploy.sh \"message\" [backend|webapp|admin|all]"
    exit 1
fi

COMMIT_MSG="$1"
TARGET="${2:-all}"

echo "🚀 Deploying proyecto-salas to production..."
echo "   Target: $TARGET"
echo ""

# 1. Git push local changes
echo "📤 Pushing local changes..."
git add .
if git commit -m "$COMMIT_MSG"; then
    git push origin main
    echo "✅ Changes pushed to GitHub"
else
    echo "ℹ️  No local changes to commit"
fi

# 2. Pull on server
echo ""
echo "📥 Pulling changes on server..."
ssh $SERVER "cd $REMOTE_PATH && git pull origin main"

# 3. Restart services if needed
echo ""
case "$TARGET" in
    backend)
        echo "♻️  Restarting backend API..."
        ssh $SERVER "cd $REMOTE_PATH/backend-api && docker-compose restart api"
        echo "✅ Backend restarted"
        ;;
    webapp)
        echo "✨ WebApp updated (static files, no restart needed)"
        ;;
    admin)
        echo "♻️  Restarting admin panel..."
        ssh $SERVER "docker restart vita-admin"
        echo "✅ Admin restarted"
        ;;
    all)
        echo "♻️  Restarting all services..."
        ssh $SERVER "cd $REMOTE_PATH/backend-api && docker-compose restart api"
        ssh $SERVER "docker restart vita-admin" || echo "⚠️  vita-admin not running (might need initial setup)"
        echo "✅ All services restarted"
        ;;
    *)
        echo "⚠️  Unknown target: $TARGET (skipping restart)"
        ;;
esac

# 4. Show URLs
echo ""
echo "✅ Deploy complete!"
echo ""
echo "📍 Live URLs:"
echo "   WebApp: http://157.245.1.231:8000/static/test-app/"
echo "   API:    http://157.245.1.231:8000/docs"
echo "   Admin:  http://157.245.1.231:8081/"
echo "   Health: http://157.245.1.231:8000/health"
echo ""
echo "🔍 Check logs:"
echo "   ssh $SERVER 'docker logs -f vita-api-api-1'"
echo "   ssh $SERVER 'docker logs -f vita-admin'"
