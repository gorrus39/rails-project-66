# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_checks
#
#  id            :integer          not null, primary key
#  aasm_state    :string           default("request"), not null
#  details       :json
#  passed        :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  commit_id     :string
#  repository_id :integer          not null
#
# Indexes
#
#  index_repository_checks_on_repository_id  (repository_id)
#
# Foreign Keys
#
#  repository_id  (repository_id => repositories.id)
#
class Repository::Check < ApplicationRecord # rubocop:disable Style/ClassAndModuleChildren
  include AASM
  belongs_to :repository

  aasm do
    state :request, initial: true
    state :success, :fail

    event :to_success do
      transitions from: :request, to: :success
    end

    event :to_fail do
      transitions from: :request, to: :fail
    end
  end
end
