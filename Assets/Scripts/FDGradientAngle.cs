using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FDGradientAngle : LineGradient
{
	public Vector2 Center = new Vector2(0.5f, 0.5f);

	protected override void UpdateGradient()
	{
		base.UpdateGradient();

		if (GradientMat != null)
		{
			GradientMat.SetFloat("_CenterX", Center.x);
			GradientMat.SetFloat("_CenterY", Center.y);
			GradientMat.SetFloat("_ScaleX", transform.localScale.x);
			GradientMat.SetFloat("_ScaleY", transform.localScale.y);
		}
	}
}
