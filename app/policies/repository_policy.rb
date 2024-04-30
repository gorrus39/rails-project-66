# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def show?
    user == record.user
  end

  def new?
    user == record.user
  end

  def create?
    user == record.user
  end
end
