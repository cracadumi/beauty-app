class FbUserService
  def self.find_or_create_by_facebook_id(data)
    user = get_by_id(data['id'])
    user = get_by_email(data['email'], data['id']) unless user
    user = create_new(data) unless user
    user.persisted? && !user.archived? ? user : nil
  end

  def self.get_by_id(fb_id)
    User.find_by(facebook_id: fb_id)
  end

  def self.get_by_email(email, fb_id)
    user = User.find_by(email: email)
    if user
      user.update_attribute :facebook_id, fb_id
      return user
    end
  end

  def self.create_new(data)
    user = User.create!(facebook_id: data['id'], bio: data['bio'],
                        dob_on: dob(data['birthday']), email: data['email'],
                        name: data['first_name'], surname: data['last_name'],
                        sex: sex(data['gender']), active: true,
                        password: Devise.friendly_token.first(6))
    user.send_welcome_message if user.persisted?
    user
  end

  def self.dob(date)
    date.present? ? Date.strptime(date, '%m/%d/%Y') : nil
  end

  def self.sex(sex)
    User.sexes.include?(sex) ? sex : nil
  end
end
