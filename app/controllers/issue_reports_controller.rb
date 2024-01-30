class IssueReportsController < ApplicationController
  before_action :set_issue_report, only: %i[show update add_talk]

  # GET /issue_reports
  def index
    @issue_reports = IssueReportResource.all(params)

    render jsonapi: @issue_reports
  end

  # GET /issue_reports/1
  def show
    IssueReportResource.new.authorize_from_resource_proxy(:read, @issue_report)
    render jsonapi: @issue_report
  end

  # POST /issue_reports
  def create
    @issue_report = IssueReportResource.build(params)
    if @issue_report.save
      render jsonapi: @issue_report, status: :created
    else
      render jsonapi_errors: @issue_report, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /issue_reports/1
  def update
    if @issue_report.update_attributes
      render jsonapi: @issue_report
    else
      render jsonapi_errors: @issue_report, status: :unprocessable_entity
    end
  end

  # POST /issue_reports/1/talks
  def add_talk
    IssueReportResource.new.authorize :update, @issue_report

    raise ActionController::BadRequest, I18n.t("errors.issue_report.blank_talk") if params.dig("talks",
                                                                                               "message").blank?

    talks_params = params["talks"]
    stored_talks = @issue_report.talks
    talk_id = "#{params['id']}_#{stored_talks.count}"

    talk = {
      id: talk_id,
      message: talks_params["message"],
      author: {
        id: @current_user.id,
        name: @current_user.full_name
      },
      created_at: DateTime.now.to_s
    }

    stored_talks.push(talk)

    if @issue_report.update(talks: stored_talks)
      render json: @issue_report
    else
      render json_errors: @issue_report, status: :unprocessable_entity
    end
  end

  # POST /issue_reports/1/images
  def add_images
    validate_images_params

    @files = params[:file]
    saved_count = 0
    @files.each_with_index do |file, index|
      tmp_file = TmpFile.new({
                               resource_type: "IssueReport",
                               resource_id: params["id"],
                               filename: "#{params['id']}_#{index}",
                               file_data: file.read
                             })
      saved_count += 1 if tmp_file.save
    end

    render json: {
      id: params["id"],
      received: saved_count
    }, status: :created
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_issue_report
    @issue_report = if %i[show update].include?(action_name.to_sym)
                      IssueReportResource.find(params)
                    else
                      IssueReport.find(params[:id].to_i)
                    end
  end

  def current_ability
    @current_ability ||= IssueReportAbility.new(@current_user)
  end

  def validate_images_params
    @files = params[:file]

    raise Rescueable::UnprocessableEntity, "File params should be an array of files" unless @files.is_a?(Array)

    raise Rescueable::UnprocessableEntity, "Upload has no file" if @files.empty?

    raise Rescueable::UnprocessableEntity, "File params count should not exceed 3" if @files.count > 3

    issue_report = IssueReport.find(params["id"])
    raise Rescueable::UnprocessableEntity, "IssueReport already has file" if issue_report.imgs.present?
  end
end
