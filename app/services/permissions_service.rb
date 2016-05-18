class PermissionsService

  extend Forwardable

  def_delegators :user, :platform_admin?,
                         :store_admin?,
                         :registered_user?

  def initialize(user, controller, action)
    @_user = user || User.new
    @_controller = controller
    @_action = action
  end

  def allow?
    case
    when platform_admin?  then platform_admin_permissions
    when store_admin?     then store_admin_permissions
    when registered_user? then registered_user_permissions
    else
      guest_permissions
    end
  end

  private

  def platform_admin_permissions
    return true if controller == "sessions"
    return true if controller == "jobs"  && action.in?(%w(index new create show edit update delete store_jobs))
    return true if controller == "users_jobs" && action.in?(%w(index show))
    return true if controller == "users" && action.in?(%w(index new create show edit update delete admin_index))
    return true if controller == "companies"  && action.in?(%w(index new create show active_companies inactive_companies inactivate_company activate_company edit update))
    return true if controller == "contact_us"  && action.in?(%w(index new create show delete))
    return true if controller == "favorites_jobs"  && action.in?(%w(index new create show destroy))
    return true if controller == "home"  && action.in?(%w(index about_us))
    return true if controller == "submissions" && action.in?(%w(index new create show edit update approved_index denied_index approved_submissions denied_submissions))
    return true if controller == "search"  && action.in?(%w(show))
    return true if controller == "company/jobs" && action.in?(%w(show))
    return true if controller == "saved_favorites" && action.in?(%w(create index))

  end

  def store_admin_permissions
    return true if controller == "sessions"
    return true if controller == "jobs"  && action.in?(%w(index new create show edit update destroy store_jobs))
    return true if controller == "users_jobs" && action.in?(%w(index show))
    return true if controller == "users" && action.in?(%w(new create show edit update destroy admin_index))
    return true if controller == "companies"  && action.in?(%w(index show edit update))
    return true if controller == "contact_us"  && action.in?(%w(new create))
    return true if controller == "favorites"  && action.in?(%w(create show destroy))
    return true if controller == "home"  && action.in?(%w(index about_us))
    return true if controller == "search"  && action.in?(%w(show))
    return true if controller == "company/jobs" && action.in?(%w(show))
    return true if controller == "saved_favorites" && action.in?(%w(create index))

  end

  def registered_user_permissions
    return true if controller == "sessions"
    return true if controller == "jobs"  && action.in?(%w(index))
    return true if controller == "companies"  && action.in?(%w(index show))
    return true if controller == "favorites_jobs"  && action.in?(%w(create show destroy))
    return true if controller == "contact_us"  && action.in?(%w(new create))
    return true if controller == "users" && action.in?(%w(new create show edit update))
    return true if controller == "home"  && action.in?(%w(index about_us))
    return true if controller == "search"  && action.in?(%w(show))
    return true if controller == "users_jobs" && action.in?(%w(new create show))
    return true if controller == "company/jobs" && action.in?(%w(show))
    return true if controller == "submissions" && action.in?(%w(new create))
    return true if controller == "saved_favorites" && action.in?(%w(create index))
  end

  def guest_permissions
    return true if controller == "companies"  && action.in?(%w(index show))
    return true if controller == "home"  && action.in?(%w(index about_us))
    return true if controller == "contact_us"  && action.in?(%w(new create))
    return true if controller == "jobs"  && action.in?(%w(index show))
    return true if controller == "sessions" && action.in?(%w(new create destroy))
    return true if controller == "favorites_jobs"  && action.in?(%w(create show destroy))
    return true if controller == "users" && action.in?(%w(new create show edit update))
    return true if controller == "submissions" && action.in?(%w(new create))
    return true if controller == "search"  && action.in?(%w(show))
    return true if controller == "company/jobs" && action.in?(%w(show))
    return true if controller == "saved_favorites" && action.in?(%w(create index))

  end

  def controller
    @_controller
  end

  def action
    @_action
  end

  def user
    @_user
  end

end
