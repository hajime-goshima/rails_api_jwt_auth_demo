class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Allowlist

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :allowlisted_jwts, dependent: :destroy

  alias_method :jwts, :allowlisted_jwts

  # JWTトークンが設定された時にコールされる
  def on_jwt_dispatch(token, payload)
    super(token, payload)
  end
end
