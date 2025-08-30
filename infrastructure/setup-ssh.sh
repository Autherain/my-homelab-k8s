#!/bin/bash

# Script to set up SSH keys for ArgoCD
# This will generate SSH keys and help you add them to ArgoCD

echo "🔑 Setting up SSH keys for ArgoCD..."
echo ""

# Check if SSH key already exists
if [ -f ~/.ssh/argocd_key ]; then
    echo "✅ SSH key already exists at ~/.ssh/argocd_key"
    echo "Public key:"
    cat ~/.ssh/argocd_key.pub
    echo ""
else
    echo "📝 Generating new SSH key..."
    ssh-keygen -t ed25519 -C "argocd@homelab" -f ~/.ssh/argocd_key -N ""
    echo "✅ SSH key generated!"
    echo ""
fi

echo "🔑 Your SSH Public Key (add this to GitHub/GitLab):"
echo "=================================================="
cat ~/.ssh/argocd_key.pub
echo "=================================================="
echo ""

echo "📋 Next steps:"
echo "1. Copy the public key above"
echo "2. Add it to your Git provider (GitHub/GitLab)"
echo "3. Run one of these commands to add the repo to ArgoCD:"
echo ""
echo "   # For GitHub:"
echo "   argocd repo add git@github.com:YOUR_USERNAME/my-homelab-k8s.git \\"
echo "     --ssh-private-key-path ~/.ssh/argocd_key"
echo ""
echo "   # For GitLab:"
echo "   argocd repo add git@gitlab.com:YOUR_USERNAME/my-homelab-k8s.git \\"
echo "     --ssh-private-key-path ~/.ssh/argocd_key"
echo ""
echo "4. Test the connection:"
echo "   ssh -T git@github.com  # or git@gitlab.com"
echo ""

# Set proper permissions
chmod 600 ~/.ssh/argocd_key
chmod 644 ~/.ssh/argocd_key.pub

echo "✅ SSH key permissions set correctly!"
echo "🔒 Private key is readable only by you"
echo "🌐 Public key is readable by everyone"
