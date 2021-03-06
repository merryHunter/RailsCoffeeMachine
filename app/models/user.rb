class User < ActiveRecord::Base
  attr_accessible :hashed_password, :name, :password, :password_confirmation, :admin, :credit


  after_destroy :ensure_an_admin_remains
  
  validates :name, :presence => true, :uniqueness => true
  
  validates :password, :confirmation => true
  attr_accessor :password_confirmation
  attr_reader :password
  
  validate :password_must_be_present
  validates :credit, :numericality => {greater_than_or_equal_to: 0}

  def admin?
    :admin
  end

  def password=(password)
    @password = password
    
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end
  
  def authenticate(name, password)
    if user = User.find_by_name(name)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end
  
  def encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "wibble" + salt)
  end
  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "wibble" + salt)
  end
  private
  
  def password_must_be_present
    errors.add(:password, t('miss_password')) unless hashed_password.present?
  end
  
  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
  def ensure_an_admin_remains
    if User.count.zero?
      logger.error('Tried to delete last User!')
      raise "cant delete the last user"
    end
  end
end
