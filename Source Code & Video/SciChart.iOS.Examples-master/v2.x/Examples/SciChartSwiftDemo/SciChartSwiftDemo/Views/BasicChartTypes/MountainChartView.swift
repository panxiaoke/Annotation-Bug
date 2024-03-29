//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// MountainChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class MountainChartView: SingleChartLayout {
    
    override func initExample() {
        //x坐标
        let xAxis = SCIDateTimeAxis()
//        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(0.1))
        //y坐标
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
//        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        // 数据赋值
        let priceData = DataManager.getPriceDataIndu()
        let dataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        dataSeries.appendRangeX(SCIGeneric(priceData!.dateData()), y: SCIGeneric(priceData!.closeData()), count: priceData!.size())
        
        // 渲染颜色
        let rSeries = SCIFastMountainRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.zeroLineY = 10000
        
        rSeries.areaStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xAAFF8D42, finish: 0x88090E11, direction: .vertical)
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xAAFFC9A8, withThickness: 1.0)
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCITooltipModifier()])
            
            rSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
