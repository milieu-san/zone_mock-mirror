# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                       :bigint           not null, primary key
#  allow_password_change    :boolean          default(FALSE)
#  confirmation_sent_at     :datetime
#  confirmation_token       :string(255)
#  confirmed_at             :datetime
#  current_sign_in_at       :datetime
#  current_sign_in_ip       :string(255)
#  email                    :string(255)      not null
#  encrypted_password       :string(255)      default(""), not null
#  last_sign_in_at          :datetime
#  last_sign_in_ip          :string(255)
#  name                     :string(255)      not null
#  onetime_token            :string(255)
#  onetime_token_created_at :datetime
#  provider                 :string(255)      default("email"), not null
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string(255)
#  sign_in_count            :integer          default(0), not null
#  tokens                   :text(65535)
#  uid                      :string(255)      default(""), not null
#  unconfirmed_email        :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  ui_users_01  (name) UNIQUE
#  ui_users_02  (email) UNIQUE
#  ui_users_03  (uid,provider) UNIQUE
#  ui_users_04  (reset_password_token) UNIQUE
#  ui_users_05  (confirmation_token) UNIQUE
#
class UserSerializer < AbstractSerializer
  def key
    :user
  end

  def simple(user)
    {
      id: user.id,
      name: user.name
    }
  end
end
