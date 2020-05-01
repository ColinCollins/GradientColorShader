using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LineGradient : MonoBehaviour
{
    const int MAX_COLORS = 5;

    public Material GradientMat;
    public int ColorCount;
    public Color[] Colors = new Color[MAX_COLORS];
    [Range(0, 1f)]
    public float[] Positions = new float[MAX_COLORS];

    protected virtual void Awake() 
    {
        UpdateGradient();
    }

    
    protected virtual void UpdateGradient ()
    {
        if (GradientMat != null) 
        {
            GradientMat.SetColorArray("_GradientColors", Colors);
            GradientMat.SetFloatArray("_GradientPositions", Positions);
            GradientMat.SetInt("_ColorCount", ColorCount);
        }
    }

#if UNITY_EDITOR
    
    protected virtual void OnValidate() 
    {
        UpdateGradient();
    }

#endif
}
