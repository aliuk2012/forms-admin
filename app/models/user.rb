class User < ApplicationRecord
  include GDS::SSO::User

  belongs_to :organisation, optional: true

  serialize :permissions, Array

  enum :role, {
    super_admin: "super_admin",
    editor: "editor",
  }

  validates :role, presence: true
  validates :organisation_id, presence: true, if: -> { organisation_id_was.present? }
  validates :has_access, inclusion: [true, false]

  def self.find_for_gds_oauth(auth_hash)
    auth_hash = auth_hash.to_hash
    find_for_auth(
      uid: auth_hash["uid"],
      email: auth_hash["info"]["email"],
      name: auth_hash["info"]["name"],
      permissions: auth_hash["extra"]["user"]["permissions"],
      organisation_slug: auth_hash["extra"]["user"]["organisation_slug"],
      organisation_content_id: auth_hash["extra"]["user"]["organisation_content_id"],
      disabled: auth_hash["extra"]["user"]["disabled"],
    )
  end

  def self.find_for_auth(attributes)
    user = where(uid: attributes[:uid]).first ||
      where(email: attributes[:email]).first

    if user
      user.update!(attributes)
      user
    else # Create a new user.
      create!(attributes)
    end
  end
end
