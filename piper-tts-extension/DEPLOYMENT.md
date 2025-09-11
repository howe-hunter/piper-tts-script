# Deployment Guide: Piper TTS Raycast Extension

This guide walks you through testing and publishing the Piper TTS extension to the Raycast Store.

## 📋 Pre-Deployment Checklist

### ✅ Extension Requirements Met:
- [x] Extension builds successfully (`npm run build`)
- [x] All commands work with no-view mode  
- [x] Icon in PNG format (512x512px)
- [x] Valid package.json with required fields
- [x] README.md with comprehensive documentation
- [x] MIT license specified
- [x] Code follows Raycast guidelines

### ✅ Functionality Tested:
- [x] Clipboard reading works correctly
- [x] Text-to-speech synthesis works
- [x] Speed variations work (different rates)
- [x] Error handling for empty clipboard
- [x] Preferences system works
- [x] Toast notifications display properly

### ✅ Code Quality:
- [x] TypeScript compilation successful
- [x] ESLint rules followed
- [x] Prettier formatting applied
- [x] No console.log statements in production code

## 🧪 Testing Phase

### Local Testing Steps:

1. **Build the extension:**
   ```bash
   npm run build
   ```

2. **Test in development mode:**
   ```bash
   npm run dev
   ```
   - This opens Raycast in development mode
   - Test all three commands with different clipboard content

3. **Test clipboard functionality:**
   ```bash
   # Copy test content
   echo "This is a test message for text-to-speech" | pbcopy
   
   # Test each command in Raycast:
   # - Speak Clipboard
   # - Speak with Speed (1.5x) 
   # - TTS Preferences
   ```

4. **Test edge cases:**
   - Empty clipboard
   - Very long text (500+ characters)
   - Special characters and emojis
   - Different languages

### Automated Testing:

```bash
# Lint check
npm run lint

# Build verification  
npm run build

# Check package.json validity
cat package.json | jq '.' > /dev/null && echo "✅ Valid JSON"
```

## 🚀 Publishing to Raycast Store

### Step 1: Prepare for Publishing

1. **Update author information:**
   ```json
   {
     "author": "your-raycast-username"
   }
   ```
   Replace `template-user` with your actual Raycast username.

2. **Final quality check:**
   ```bash
   npm run build
   npm run lint
   ```

### Step 2: Create Raycast Store Account

1. Visit [raycast.com](https://raycast.com)
2. Create an account or sign in
3. Note your username for the package.json author field

### Step 3: Publish Extension

1. **Use the publish command:**
   ```bash
   npm run publish
   ```

2. **Follow the prompts:**
   - Login to your Raycast account
   - Confirm extension details
   - Submit for review

3. **Monitor the submission:**
   - Check your email for review notifications
   - Respond to any feedback from the Raycast team
   - Make requested changes if needed

### Step 4: Post-Publishing

1. **Share your extension:**
   - Tweet about it with @raycastapp
   - Share in relevant communities
   - Add to your GitHub profile

2. **Monitor usage:**
   - Check Raycast Store analytics
   - Respond to user feedback
   - Plan future updates

## 📚 Documentation Standards

### README Requirements:
- Clear description of what the extension does
- Step-by-step installation instructions
- Usage examples with screenshots
- Troubleshooting section
- Credits and acknowledgments

### Code Documentation:
- TypeScript interfaces properly documented
- Complex functions have explanatory comments
- Error messages are user-friendly
- Toast notifications provide clear feedback

## 🔧 Maintenance

### Regular Updates:
- Keep dependencies up to date
- Test with new Raycast versions
- Add new features based on user feedback
- Fix bugs promptly

### Version Management:
- Follow semantic versioning
- Document changes in CHANGELOG.md
- Test thoroughly before each release

## 🎯 Success Metrics

Track these metrics post-launch:
- Downloads and active users
- User ratings and reviews  
- GitHub stars and forks
- Community feedback and feature requests

## 🆘 Troubleshooting Common Issues

### Build Failures:
- Check TypeScript errors: `npm run build`
- Verify imports and exports
- Ensure all assets exist

### Lint Issues:
- Run auto-fix: `npm run fix-lint`
- Check package.json format
- Verify icon file format (PNG)

### Runtime Errors:
- Test clipboard permissions
- Verify system speech synthesis works
- Check error handling in all commands

## 📞 Support

If you encounter issues:
1. Check Raycast documentation: [developers.raycast.com](https://developers.raycast.com)
2. Join Raycast Slack community
3. Open GitHub issues for bugs
4. Contact Raycast support for store-related issues

---

**Ready to publish?** Your extension is production-ready and meets all Raycast Store requirements! 🎉
