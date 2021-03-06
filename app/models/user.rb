class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

has_many :links
has_many :votes
has_many :jobs
has_many :groups

has_many :comments
has_many :follow_groups
has_many :groups, through: :follow_groups

    def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end
  
      def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end
  
  
validates :username,
  :uniqueness => {
    :case_sensitive => false
  }




has_attached_file :avatar, :styles => { :main => "200x200#" },
                  :url  => "/assets/products/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"


validates_attachment_size :avatar, :less_than => 5.megabytes
validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']

def follow_group(group_id)
	group = Group.find(group_id)
	FollowGroup.create(user_id: id, group_id: group_id)
end
  
def email_required?
    false
  end

end
