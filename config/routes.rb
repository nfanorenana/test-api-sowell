# frozen_string_literal: true

Rails.application.routes.draw do
  scope path: ApplicationResource.endpoint_namespace, defaults: { format: :jsonapi } do
    resources :spots, except: %i[update destroy]
    resources :visit_reports, except: %i[update destroy]
    resources :checkpoints, only: %i[show index]
    resources :checklists, only: %i[show index]
    resources :visit_schedules, only: %i[show index]
    resources :agencies, only: %i[show index]
    resources :companies
    resources :issue_types, only: %i[show index]
    resources :issue_reports, except: :destroy
    resources :location_types, only: %i[show index]
    resources :places, only: %i[show index]
    resources :residences, only: %i[show index]
    resources :users, except: :destroy
    resources :sectors
    resources :roles, except: :update
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  end
  post "/sign-in" => "auth#sign_in_password"
  post "/sign-in-otp" => "auth#sign_in_one_time_password"
  post "/send-otp" => "auth#send_one_time_password"
  post "/issue_reports/:id/images" => "issue_reports#add_images"
  post "/issue_reports/:id/talks" => "issue_reports#add_talk"
  post "/sectors/:id/add-places" => "sectors#add_places"
  delete "/sectors/:id/delete-places" => "sectors#delete_places"
end
