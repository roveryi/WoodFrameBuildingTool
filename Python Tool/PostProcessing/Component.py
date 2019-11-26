class component(object):

	# Define Component class to build FEMA P-58 database
	# Author: Zhengxiang Yi
	# Date: 07/18/2018
	# Email: roveryi@g.ucla.edu

	def __init__(self, ID, Name, Description, DemandParameter, NumDS, DSHierarchy, Unit, Measure, DSProb, EDPMean, EDPStd, Directional, LossDist, LossStd,\
	 LossLowQty, LossLowMean, LossUpQty, LossUpMean, DTDist, DTStd, DTLowQty, DTLowMean, DTUpQty, DTUpMean, CostScalar):
		# Component ID, when used should look into the FEMA P-58 spreadsheet to refer the component ID
		self.ID = ID 

		# Component name, when used should look into the FEMA P-58 spreadsheet to refer the component name
		self.Name = Name 

		# Component name, when used should look into the FEMA P-58 spreadsheet to refer the component description
		self.Description = Description 

		# Component demand parameter, which kind of EDP this component is sensitive to
		self.DemandParameter = DemandParameter

		# Number of damage states for this component. The hierarchy of damage states may be mutually exclusive or sequential. NumDS consider all possible damage states.
        # When applied in computation, user should give specific damage states considered here, because mutually exclusive damage states are parallel and CANNOT be considered at the same time.
        # Specifically, mutually exclusive damage states should be considered at the same time by different proportion of contribution to the total loss at current story. 
		self.NumDS = NumDS 

		# Damage state hierarchy describes the relationshipe between damage states, mutually exclusive and sequential
		self.DSHierarchy = DSHierarchy

		# Unit of current components, measure is the unit measurement of current component 
		self.Unit = Unit
		self.Measure = Measure

		# Damage state probability describes the proportion of contribution of mutually exclusive damage states in a story
		self.DSProb = DSProb

		# The component damage fragility function mean and dispersion 
		self.EDPMean = EDPMean
		self.EDPStd = EDPStd

		# Whether the current considered component should be counted in 2 direction or not
		self.Directional = Directional

		# The loss information of damage state, to be noted, the actual loss should use linear interpolation between lower and upper cut off.
		# The rationality behind this is repair of low quantity components will be more than high quantity components.
		self.LossDist = LossDist
		self.LossStd = LossStd
		self.LossLowQty = LossLowQty
		self.LossLowMean = LossLowMean
		self.LossUpQty = LossUpQty
		self.LossUpMean = LossUpMean

		# The downtime information of damage state, to be noted, the actual downtime should use linear interpolation between lower and upper cut off.
		self.DTDist = DTDist
		self.DTStd = DTStd
		self.DTLowQty = DTLowQty
		self.DTLowMean = DTLowMean
		self.DTUpQty = DTUpQty
		self.DTUpMean = DTUpMean

		self.CostScalar = CostScalar