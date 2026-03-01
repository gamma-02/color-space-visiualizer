shader_type spatial;
render_mode unshaded;
render_mode cull_disabled;

const float ONE_THIRD = 1.0f/3.0f;
const vec3 ONE_THIRD_VEC = vec3(ONE_THIRD, ONE_THIRD, ONE_THIRD);

const vec3 M11 = vec3(0.4122214708, 0.5363325363, 0.0514459929),
  M12 = vec3(0.2119034982, 0.6806995451, 0.1073969566),
  M13 = vec3(0.0883024619, 0.2817188376, 0.6299787005);

const vec3 M21 = vec3(0.2104542553, 0.7936177850, -0.0040720468),
  M22 = vec3(1.9779984951, -2.4285922050, 0.4505937099),
  M23 = vec3(0.0259040371, 0.7827717662, -0.8086757660);

const mat3 M1 = mat3(M11, M12, M13);
const mat3 M2 = mat3(M21, M22, M23);

const mat3 I3 = mat3(vec3(1, 0, 0), vec3(0, 1, 0), vec3(0, 0, 1));

const vec3 offsetToOrigin = vec3(-0.5f, 0.0f, 0.0f);

//OkHSV/OkHSL constants
const float K1 = 0.206;
const float K2 = 0.03;
const float K3 = (1. + K1) / (1. + K2);

uniform float rgb_lab_interp : hint_range(0.0f, 1.0f);

vec3 cbrtf(vec3 x){
	return pow(x, ONE_THIRD_VEC);
}

vec3 rgbToLAB(vec3 RGB){
	vec3 lms = RGB * M1;
	vec3 llms = cbrtf(lms);
	vec3 lab = llms * M2;
	
	lab.x = .5 * (K3 * lab.x - K1 + sqrt((K3 * lab.x - K1) * (K3 * lab.x - K1) + 4. * K2 * K3 * lab.x));
	
	return lab;
}

// Called for every vertex the material is visible on.
void vertex() {
	//transform mesh pos to [0, 1] space
	vec3 transformedModelPos = VERTEX + vec3(0.5f, 0.5f, 0.5f);
	
	transformedModelPos = pow(transformedModelPos, vec3(2));
	
	//set the varying vertex position for the fragment shader
	COLOR.xyz = transformedModelPos;

	//convert world pos to LAB pos
	vec3 labTransformed = rgbToLAB(transformedModelPos) + offsetToOrigin;
	
	//set and interpolate between rgb and LAB
	VERTEX.yzx = mix(labTransformed, VERTEX.yzx, rgb_lab_interp);
}

// Called for every pixel the material is visible on.
void fragment() {
	//set the color of each pixel to the xyz of said pixel
	ALBEDO.rgb = COLOR.xyz;
}
