class SubmissionsController < ApplicationController

  def index
    @submissions = Submission.where(approval: 0) || []
  end

  def new
    @submission = Submission.new
  end

  def create
    @submission = Submission.new(submissions_params)
    if @submission.save
      flash[:success] = "Thank you for your interest. A Ziba specialist will reach out to you soon"
      redirect_to root_path
    else
      flash[:error] = "Invalid Info. Please try again"
      render :new
    end
  end

  def show
    @submission = Submission.find_by(company_name:params[:company_name])
  end

  def approved_index
    submission = Submission.where(approval: 1) || []
    @submissions = submission.paginate(:page => params[:page], :per_page => 10)
  end

  def approved_submissions
    submission = Submission.find(params[:id])
    @company = submission.create_company
    user = submission.create_user(@company)
    approved_status
  end

  def denied_index
    submission  = Submission.where(approval: 2) || []
    @submissions = submission.paginate(:page => params[:page], :per_page => 10)
  end

  def denied_submissions
    Submission.find_by(company_name: params[:company_name]).update(approval: 2)
    redirect_to companies_denied_path
  end

  def approved_status
    status = Submission.find_by(company_name:@company.name)
    status.approve! if !status.nil?
    flash.now[:error] = "You can't approve the same Submission Again"
    redirect_to companies_approved_path
  end


  private


  def submissions_params
    params.require(:submission).permit(:company_name, :logo, :url, :size_of_company, :industry, :about_company, :first_name, :last_name, :email, :phone_number, :description, :authenticity_token)
  end
end
