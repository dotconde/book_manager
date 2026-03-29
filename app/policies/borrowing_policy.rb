class BorrowingPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.member?
  end

  def return?
    user.librarian?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.librarian?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
