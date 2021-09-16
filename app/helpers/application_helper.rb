module ApplicationHelper

	# Create data
	def store(model, data, authorize = false)
		exe = model.new(data)

		if authorize
			authorize exe, :create?
		end

		exe.image_derivatives! if exe.image.present?

		exe.save!
	end

	# Update data
	def edit(model, data, id, authorize = false)
		exe = model.find(id)

		if authorize
			authorize exe, :update?
		end
		
		exe.image_derivatives! if exe.image.present?

		exe.update!(data)
	end

	# Delete data
	def destroy(model, id, authorize = false)
		exe = model.find(id)

		if authorize
			authorize exe, :delete?
		end

		exe.destroy!
	end
end
