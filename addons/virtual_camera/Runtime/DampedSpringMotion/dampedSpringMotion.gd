#/******************************************************************************
  #Copyright (c) 2008-2012 Ryan Juckett
  #http://www.ryanjuckett.com/
 #
  #This software is provided 'as-is', without any express or implied
  #warranty. In no event will the authors be held liable for any damages
  #arising from the use of this software.
 #
  #Permission is granted to anyone to use this software for any purpose,
  #including commercial applications, and to alter it and redistribute it
  #freely, subject to the following restrictions:
 #
  #1. The origin of this software must not be misrepresented; you must not
	 #claim that you wrote the original software. If you use this software
	 #in a product, an acknowledgment in the product documentation would be
	 #appreciated but is not required.
 #
  #2. Altered source versions must be plainly marked as such, and must not be
	 #misrepresented as being the original software.
 #
  #3. This notice may not be removed or altered from any source
	 #distribution.
#******************************************************************************/

#******************************************************************************
# JoaoSant0s
# Converting the C++ to GDScript with type and context use
# Original Code: https://www.ryanjuckett.com/damped-springs/
#******************************************************************************

#******************************************************************************
# Cached set of motion parameters that can be used to efficiently update
# multiple springs using the same time step, angular frequency and damping
# ratio.
#******************************************************************************
class_name dampedSpringMotion

const epsilon : float = 0.0001

#******************************************************************************
# This function will compute the parameters needed to simulate a damped spring
# over a given period of time.
# - An angular frequency is given to control how fast the spring oscillates.
# - A damping ratio is given to control how fast the motion decays.
#     damping ratio > 1: over damped
#     damping ratio = 1: critically damped
#     damping ratio < 1: under damped
#******************************************************************************

static func CalcDampedSpringMotionParams(
	pOutParams : tDampedSpringMotionParams,       # motion parameters result
	deltaTime : float,        # time step to advance
	angularFrequency : float, # angular frequency of motion
	dampingRatio : float):     # damping ratio of motion

	# force values into legal range
	if dampingRatio < 0.0: dampingRatio = 0.0
	if angularFrequency < 0.0: angularFrequency = 0.0

	# if there is no angular frequency, the spring will not move and we can
	# return identity
	if angularFrequency < epsilon:	
		pOutParams.posPosCoef = 1.0;
		pOutParams.posVelCoef = 0.0
		pOutParams.velPosCoef = 0.0 
		pOutParams.velVelCoef = 1.0
		return;

	if dampingRatio > 1.0 + epsilon:
		# over-damped
		var za : float = -angularFrequency * dampingRatio;
		var zb  : float= angularFrequency * sqrt(dampingRatio*dampingRatio - 1.0);
		var z1 : float= za - zb;
		var z2 : float= za + zb;

		var e1 : float = exp(z1 * deltaTime );
		var e2 : float = exp( z2 * deltaTime );

		var invTwoZb : float = 1.0 / (2.0*zb); # = 1 / (z2 - z1)
			
		var e1_Over_TwoZb : float = e1 * invTwoZb;
		var e2_Over_TwoZb : float = e2 * invTwoZb;

		var z1e1_Over_TwoZb : float = z1 * e1_Over_TwoZb;
		var z2e2_Over_TwoZb : float = z2 * e2_Over_TwoZb;

		pOutParams.posPosCoef =  e1_Over_TwoZb * z2 - z2e2_Over_TwoZb + e2;
		pOutParams.posVelCoef = -e1_Over_TwoZb + e2_Over_TwoZb;

		pOutParams.velPosCoef = (z1e1_Over_TwoZb - z2e2_Over_TwoZb + e2) * z2;
		pOutParams.velVelCoef = -z1e1_Over_TwoZb + z2e2_Over_TwoZb;
	elif dampingRatio < 1.0 - epsilon:	
		# under-damped
		var omegaZeta : float = angularFrequency * dampingRatio;
		var alpha : float = angularFrequency * sqrt(1.0 - dampingRatio*dampingRatio);

		var expTerm : float = exp( -omegaZeta * deltaTime );
		var cosTerm : float = cos( alpha * deltaTime );
		var sinTerm : float = sin( alpha * deltaTime );
			
		var invAlpha : float = 1.0 / alpha;

		var expSin : float = expTerm * sinTerm;
		var expCos : float = expTerm * cosTerm;
		var expOmegaZetaSin_Over_Alpha : float = expTerm*omegaZeta*sinTerm * invAlpha;

		pOutParams.posPosCoef = expCos + expOmegaZetaSin_Over_Alpha;
		pOutParams.posVelCoef = expSin * invAlpha;

		pOutParams.velPosCoef = -expSin * alpha - omegaZeta*expOmegaZetaSin_Over_Alpha;
		pOutParams.velVelCoef =  expCos - expOmegaZetaSin_Over_Alpha;	
	else:
		# critically damped
		var expTerm :float = exp( -angularFrequency*deltaTime );
		var timeExp :float = deltaTime*expTerm;
		var timeExpFreq :float = timeExp*angularFrequency;

		pOutParams.posPosCoef = timeExpFreq + expTerm;
		pOutParams.posVelCoef = timeExp;

		pOutParams.velPosCoef = -angularFrequency*timeExpFreq;
		pOutParams.velVelCoef = -timeExpFreq + expTerm;	
	
#******************************************************************************
# This function will update the supplied position and velocity values over
# according to the motion parameters.
#******************************************************************************

static func UpdateDampedSpringMotion(
	pVel : float                           ,        
	pPos : float,           
	equilibriumPos : float                      , # position to approach
	params : tDampedSpringMotionParams):   # motion parameters to use
	
	var oldPos : float = pPos - equilibriumPos; # update in equilibrium relative space
	var oldVel : float = pVel;
	
	return {
		"pVel" : oldPos * params.velPosCoef + oldVel * params.velVelCoef,    # velocity value to update
		"pPos" : oldPos * params.posPosCoef + oldVel * params.posVelCoef + equilibriumPos # position value to update	
	}
	
static func UpdateDampedSpringMotionVector(
	pVel : Vector3                           ,        
	pPos : Vector3,           
	equilibriumPos : Vector3                      , # position to approach
	params : tDampedSpringMotionParams):   # motion parameters to use
	
	var oldPos : Vector3 = pPos - equilibriumPos; # update in equilibrium relative space
	var oldVel : Vector3 = pVel;
	
	var result = {
		"pVel" : oldPos * params.velPosCoef + oldVel * params.velVelCoef,    # velocity value to update
		"pPos" : oldPos * params.posPosCoef + oldVel * params.posVelCoef + equilibriumPos # position value to update	
	}
	return result
