#!/usr/bin/env bash
# A committed, correct cart total, then an uncommitted change that drops the quantity.
set -euo pipefail

git init -q -b main .
git config user.email eval@example.com
git config user.name "Eval User"

mkdir -p src
cat > src/cart.js <<'EOF'
function cartTotal(items) {
  return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
}

module.exports = { cartTotal };
EOF
git add src/cart.js
git commit -qm "feat: cart total"

cat > src/cart.js <<'EOF'
function cartTotal(items) {
  // simplified total
  return items.reduce((sum, item) => sum + item.price, 0);
}

module.exports = { cartTotal };
EOF
