# == Schema Information
#
# Table name: repositories
#
#  id         :integer          not null, primary key
#  clone_url  :string
#  full_name  :string
#  language   :string
#  name       :string
#  ssh_url    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  github_id  :string           not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_repositories_on_github_id  (github_id) UNIQUE
#  index_repositories_on_user_id    (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
end
