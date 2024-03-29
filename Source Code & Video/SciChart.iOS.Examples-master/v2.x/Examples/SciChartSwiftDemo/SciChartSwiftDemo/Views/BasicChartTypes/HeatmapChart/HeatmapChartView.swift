//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// HeatmapChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class HeatmapChartView: HeatmapChartLayout {
    
    let height: Int32 = 200
    let width: Int32 = 300
    let seriesPerPeriod = 30
    let timeInterval = 0.04
    
    var _dataSeries : SCIUniformHeatmapDataSeries!
    var _timerIndex: Int = 0
    var timer: Timer!
    var _running: Bool = false
    var data = [SCIGenericType]()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateHeatmapData), userInfo: nil, repeats: true)
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    override func initExample() {
        surface.leftAxisAreaForcedSize = 0.0;
        surface.topAxisAreaForcedSize = 0.0;
        
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        
        _dataSeries = SCIUniformHeatmapDataSeries(typeX: .int32, y: .int32, z: .double, sizeX: width, y: height, startX: SCIGeneric(0.0), stepX: SCIGeneric(1.0), startY: SCIGeneric(0.0), stepY: SCIGeneric(1.0))

        let stops = [NSNumber(value: 0.0), NSNumber(value: 0.2), NSNumber(value: 0.4), NSNumber(value: 0.6), NSNumber(value: 0.8), NSNumber(value: 1.0)]
        let colors = [UIColor.fromARGBColorCode(0xFF00008B)!, UIColor.fromARGBColorCode(0xFF6495ED)!, UIColor.fromARGBColorCode(0xFF006400)!, UIColor.fromARGBColorCode(0xFF7FFF00)!, UIColor.fromARGBColorCode(0xFFFFFF00)!, UIColor.fromARGBColorCode(0xFFFF0000)!]
        
        let heatmapRenderableSeries = SCIFastUniformHeatmapRenderableSeries()
        heatmapRenderableSeries.minimum = 0.0
        heatmapRenderableSeries.maximum = 200.0
//        heatmapRenderableSeries.colorMap = SCIColorMap(colors: colors, andStops: stops)
        heatmapRenderableSeries.dataSeries = _dataSeries
        createData()
        
        heatmapColourMap.minimum = heatmapRenderableSeries.minimum
        heatmapColourMap.maximum = heatmapRenderableSeries.maximum
        heatmapColourMap.colourMap = heatmapRenderableSeries.colorMap
        
        surface.xAxes.add(xAxis)
        surface.yAxes.add(yAxis)
        surface.renderableSeries.add(heatmapRenderableSeries)
        surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCICursorModifier()])
    }
    
    fileprivate func createData() {
        for i in 0..<seriesPerPeriod {
            let angle = .pi * 2.0 * Double(i) / Double(seriesPerPeriod)
            let zValues = UnsafeMutablePointer<Double>.allocate(capacity: Int(width * height))
            let cx = 150.0
            let cy = 100.0
            
            for x in 0..<width {
                for y in 0..<height {
                    let v = (1 + sin(Double(x) * 0.04 + angle)) * 50 + (1 + sin(Double(y) * 0.1 + angle)) * 50 * (1 + sin(angle * 2))
                    let r = sqrt((Double(x) - cx) * (Double(x) - cx) + (Double(y) - cy) * (Double(y) - cy))
                    let exp = max(0, 1 - r * 0.008)
            
                    zValues[Int(x * height + y)] = v * exp + Double(arc4random_uniform(50))
                }
            }
            data.append(SCIGeneric(zValues))
        }
        _dataSeries.updateZValues(data[0], size: Int32(width * height))
    }
    
    @objc func updateHeatmapData() {
        SCIUpdateSuspender.usingWithSuspendable(surface, with: {
            self._dataSeries.updateZValues(self.data[self._timerIndex % self.seriesPerPeriod], size: Int32(self.width * self.height))
            
            self._timerIndex += 1
        })
    }
    
    deinit {
        let count = data.count
        for i in 0..<count {
            let zValues = SCIGenericDoublePtr(data[i])
            zValues?.deallocate()
        }
        
        data.removeAll()
    }
}
