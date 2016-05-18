
import UIKit
import LiferayScreens
import UIView_Shake


public class LoginView_salvito: LoginView_default {

    @IBOutlet var fieldsetView: UIView?
    
    @IBOutlet var mainView: UIView?
    
    private var usernameRightPlaceholderLabel: UILabel!
    
    private var usernameFakePlaceholderLabel: UILabel!
    
    private var passwordRightPlaceholderImage: UIImageView!
    
    private var passwordFakePlaceholderLabel: UILabel!
    
    private var font: UIFont!
    
    private var translateXUserName: CGFloat!
        {
        get {
            let attributes = [NSFontAttributeName: font!]
            let rightPlaceholderTextSize = usernameRightPlaceholderLabel.text!.sizeWithAttributes(attributes)
            let rightPlaceholderTextWidth = rightPlaceholderTextSize.width - 30;
            let translateX = CGRectGetWidth(self.userNameField.textRectForBounds(self.userNameField.frame)) - rightPlaceholderTextWidth
            return translateX
        }
    }
    
    private var translateXPassword: CGFloat!
        {
        get {
            let translateX = CGRectGetWidth(self.passwordField.textRectForBounds(self.passwordField.frame)) - 24
            return translateX
        }
    }
    
    override public func onSetTranslations() {
        //super.onSetTranslations()
        self.userNameField.placeholder = "";
        self.passwordField.placeholder = "";
        loginButton?.replaceAttributedTitle(LocalizedString("default", key: "signin-button", obj: self),
                                            forState: .Normal)
        
        authorizeButton?.replaceAttributedTitle(LocalizedString("default", key: "authorize-button", obj: self),
                                                forState: .Normal)
    }
    
    
    
    public func setupView() {
        font = self.userNameField.font;
        
        self.loginButton.layer.cornerRadius = 20; // this value vary as per your desire
        self.loginButton.clipsToBounds = true;
        
        
        usernameFakePlaceholderLabel = UILabel(frame:self.userNameField.frame)
        usernameFakePlaceholderLabel.font = font
        usernameFakePlaceholderLabel.text = LocalizedString("default",
                                                            key: BasicAuthMethod.create(basicAuthMethod).description, obj: self)
        usernameFakePlaceholderLabel.textColor = .lightGrayColor()
        usernameFakePlaceholderLabel.alpha = 1.0
        addSubview(usernameFakePlaceholderLabel)
        
        
        usernameRightPlaceholderLabel = UILabel(frame: self.userNameField.frame)
        usernameRightPlaceholderLabel.font = UIFont (name: (self.userNameField?.font!.fontName)!, size: 10)
        
        if("auth-method-email" == BasicAuthMethod.create(basicAuthMethod).description){
            usernameRightPlaceholderLabel.text = "xxxx@liferay.com";
        }else{
            usernameRightPlaceholderLabel.text = "test";
        }
        
        usernameRightPlaceholderLabel.textColor = .lightGrayColor()
        usernameRightPlaceholderLabel.alpha = 0.0
        usernameRightPlaceholderLabel.layer.zPosition = 4
        addSubview(usernameRightPlaceholderLabel)
        
        passwordFakePlaceholderLabel = UILabel(frame:self.passwordField.frame)
        passwordFakePlaceholderLabel.font = font
        passwordFakePlaceholderLabel.text = LocalizedString("default", key: "password-placeholder", obj: self)
        passwordFakePlaceholderLabel.textColor = .lightGrayColor()
        passwordFakePlaceholderLabel.alpha = 1.0
        addSubview(passwordFakePlaceholderLabel)
        
        let image = UIImage(named: "eye")
        passwordRightPlaceholderImage = UIImageView(image: image!)
        passwordRightPlaceholderImage.frame = CGRect(x: self.passwordField.frame.origin.x, y:self.passwordField.frame.origin.y + 11, width: 20, height: 20)
        passwordRightPlaceholderImage.hidden = true;
        passwordRightPlaceholderImage.userInteractionEnabled = true
        addSubview(passwordRightPlaceholderImage)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        self.passwordRightPlaceholderImage.addGestureRecognizer(longPressRecognizer)
    }
    
    override public func onCreated() {
    
        super.onCreated()
        setupView()
        
    }
    
    func longPressed(sender: UILongPressGestureRecognizer){
       
        if (sender.state.rawValue == 1) {
            self.passwordField.tintColor = .clearColor()
            self.passwordField!.secureTextEntry = false
        }else{
            self.passwordField!.secureTextEntry = true
            self.passwordField.tintColor = self.userNameField!.tintColor
        }
        
    }

    override public func onFinishInteraction(result: AnyObject?, error: NSError?) {
        
        super.onFinishInteraction(result, error: error);
        
        if(error != nil){
            fieldsetView?.shake(10,              // 10 times
                withDelta: 5.0 );
        }
        
    }
    
    
    public func didBeginEditing(notification: NSNotification) {
        
        self.userNameField.placeholder = "";
        if notification.object === self.userNameField {
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { () -> Void in
                if self.userNameField.text!.isEmpty {
                    self.usernameFakePlaceholderLabel.transform = CGAffineTransformTranslate(self.usernameFakePlaceholderLabel.transform, self.translateXUserName, 0.0)
                    self.usernameFakePlaceholderLabel.alpha = 0.0
                    
                    self.usernameRightPlaceholderLabel.transform = CGAffineTransformTranslate(self.usernameRightPlaceholderLabel.transform, self.translateXUserName, 0.0)
                    self.usernameRightPlaceholderLabel.alpha = 1.0
                }
                }, completion: nil)
            
        }
        
        if notification.object === self.passwordField {
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { () -> Void in
                if self.passwordField.text!.isEmpty {
                    self.passwordFakePlaceholderLabel.transform = CGAffineTransformTranslate(self.passwordFakePlaceholderLabel.transform, self.translateXPassword, 0.0)
                    self.passwordFakePlaceholderLabel.alpha = 0.0
                    self.passwordRightPlaceholderImage.hidden = false
                    self.passwordRightPlaceholderImage.transform = CGAffineTransformTranslate(self.passwordRightPlaceholderImage.transform, self.translateXPassword, 0.0)
                    self.passwordRightPlaceholderImage.alpha = 1.0
                }
                }, completion: nil)
            
        }
        
    }
    
    public func didEndEditing(notification: NSNotification) {
        if notification.object === self.userNameField {
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { () -> Void in
                if self.userNameField.text!.isEmpty {
                    self.usernameFakePlaceholderLabel.transform = CGAffineTransformTranslate(self.usernameFakePlaceholderLabel.transform, -self.translateXUserName, 0.0)
                    self.usernameFakePlaceholderLabel.alpha = 1.0
                    
                    self.usernameRightPlaceholderLabel.transform = CGAffineTransformTranslate(self.usernameRightPlaceholderLabel.transform, -self.translateXUserName, 0.0)
                    self.usernameRightPlaceholderLabel.alpha = 0.0
                }
                }, completion: nil)
        }
        
        if notification.object === self.passwordField {
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { () -> Void in
                if self.passwordField.text!.isEmpty {
                    self.passwordFakePlaceholderLabel.transform = CGAffineTransformTranslate(self.passwordFakePlaceholderLabel.transform, -self.translateXPassword, 0.0)
                    self.passwordFakePlaceholderLabel.alpha = 1.0
                    self.passwordRightPlaceholderImage.hidden = true
                    self.passwordRightPlaceholderImage.transform = CGAffineTransformTranslate(self.passwordRightPlaceholderImage.transform, -self.translateXPassword, 0.0)
                    self.passwordRightPlaceholderImage.alpha = 0.0
                }
                }, completion: nil)
        }
    }
    
    
    override public func willMoveToSuperview(newSuperview: UIView!) {
        
        if newSuperview != nil {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBeginEditing:", name:UITextFieldTextDidBeginEditingNotification, object: self.userNameField)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEndEditing:", name:UITextFieldTextDidEndEditingNotification, object: self.userNameField)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBeginEditing:", name:UITextFieldTextDidBeginEditingNotification, object: self.passwordField)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEndEditing:", name:UITextFieldTextDidEndEditingNotification, object: self.passwordField)
        } else {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        
    }

}
