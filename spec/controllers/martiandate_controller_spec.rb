require 'rails_helper'

RSpec.describe MartiandateController, type: :controller do
  describe 'GET index' do
    PARAMS = { id: 'lalit-martian-birthday-on-21-August-2019?' }
    shared_examples_for :render_template do |template,params|
      it template do 
        get :index, params: params
        expect(response).to render_template(template)
      end
    end  
    context 'Render Template' do
      it_behaves_like :render_template, :index
      it_behaves_like :render_template, :result, PARAMS
    end

    context 'Check' do
      it 'Instance Variable' do 
        get :index, params: PARAMS
        expect(assigns(:name)).to eq('lalit')
        expect(assigns(:birthday).to_s).to eq('2019-08-21')
        expect(assigns(:image_name).to_s).to eq('/uploads/20190821.jpg')     
      end
    end
  end
end