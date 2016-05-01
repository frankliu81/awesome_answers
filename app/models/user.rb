class User < ActiveRecord::Base
  before_create :generate_api_key

  # has_secure_password does the following:
  # 1 - it adds attribute accessors: password and password_confirmation
  # 2 - It adds validation: password must be present on creation
  # 3 - If password confirmation is present, it will make sure it's equal to password
  # 4 - Password length should be less than or equal to 72 characters
  # 5 - It will has the password using BCrypt and stores the hash
  # digest in the password_digest field
  has_secure_password

  # this was to show that you can add attr_accessor to the ActiveRecord
  # object, even though it will just exist in memory, and not be saved to the db
  # attr_accessor :abc

  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  has_many :likes, dependent: :destroy
  # we're using 'source' option in here because we used 'liked_questions' instead
  # of 'questions' (convention) because we used 'has_many :questions' earlier.
  # inside the 'like' model there is no association called 'liked_question'
  # so we have to specify the soruce for Tails to know how to match it
  has_many :liked_questions, through: :likes, source: :question

  has_many :votes, dependent: :destroy
  # source is referencing the belongs to :question in vote.rb
  has_many :voted_questions, through: :votes, source: :question

  validates :first_name, presence: true
  validates :last_name, presence: true
  #validates :email, uniqueness: true, presence: true
  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, uniqueness: true, presence: true, format: VALID_EMAIL_REGEX,
            unless:   :from_omniauth?

  # This will help you easier retrieve the raw twitter data back as a Hash
  # which will make it easire to access and manipulate.
  serialize :twitter_raw_data

  def full_name
    # if one of them is nil, it will throw exception
    # string interpolation also more efficient
    # first_name + " " + last_name
    "#{first_name} #{last_name}"
  end

  def generate_password_reset_data
    # what should the token be, can you generate a random token
    # it has to be unique
    # better to not use hash digest in this case, in case the user
    # tries to play with that and tries to figure our algorithm
    # use SecureRandom
    # 32 characters of hex
    # how do I make sure it is unique
    # don't want to put the user id in it
    generate_password_reset_token
    # when you don't do self, it will just define a local variable instead
    # we are using the attribute accessor built in with rails
    self.password_reset_requested_at = Time.now
    # save the record i the database
    save
  end

  def generate_password_reset_token
    # begin/while runs at least once
    begin
      self.password_reset_token = SecureRandom.hex(32)
      # check if something exist in ActiveRecord
    end while User.exists?(password_reset_token: self.password_reset_token)
  end

  def password_reset_expired?
    # return true if password expired
    # if the requested date is less than 60 minutes go, then it has expired,
    # return true
    password_reset_requested_at < 60.minutes.ago
  end

  # options: SecureRandom.hex,
  def generate_api_key
    self.api_key = SecureRandom.hex(32)
    while User.exists?(api_key: self.api_key)
      self.api_key = SecureRandom.hex(32)
    end
    # begin
    #     self.api_key = SecureRandom.hex(32)
    # end while User.exists?(api_key: self.api_key)
 end
   # we call self because we want to call the actual object. if we don't do do this, we would simply be setting a variable `api_key`.
   # IF WE WANT TO ONLY READ A VALUE, NO NEED TO CALL SELF. BUT IF WE WANT TO WRITE A VALUE, LET'S SELF IT.

  def from_omniauth?
    uid.present? && provider.present?
  end

  # find_from_omniauth method will fetch the user from our database using
  # their uid and provider if they exist and will give us back nil if the user
  # has not signed up with Twitter before.
  def self.find_from_omniauth(omniauth_data)
    User.where(provider: omniauth_data["provider"],
              uid:      omniauth_data["uid"]).first
  end

  # we can create the user account from the data we get
  # from OmniAuth using the create_from_omniauth method.
  def self.create_from_omniauth(omniauth_data)
    full_name = omniauth_data["info"]["name"].split
    User.create(uid:                      omniauth_data["uid"],
                provider:                 omniauth_data["provider"],
                first_name:               full_name[0],
                last_name:                full_name[1],
                twitter_consumer_token:   omniauth_data["credentials"]["token"],
                twitter_consumer_secret:  omniauth_data["credentials"]["secret"],
                twitter_raw_data:         omniauth_data,
                password:                 SecureRandom.hex(16)
                )
  end

end
