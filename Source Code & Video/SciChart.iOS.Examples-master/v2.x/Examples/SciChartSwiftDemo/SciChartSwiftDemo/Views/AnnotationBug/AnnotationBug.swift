//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// InteractionWithAnnotations.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class AnnotationBug: SingleChartLayout {
    
    var lineStyle: ForexLineStyle = .slash
    var colorStyle: ForexColorStyle = .red {
        didSet {
//            self.updateSelectAnnotationColorStyle()
        }
    }
    
    lazy var toolBar: ForexEditToolBar = {
        let bar = ForexEditToolBar(width: UIScreen.main.bounds.width)
        bar.clickHandler = { [weak self] (action) in
            guard let self = self else {
                return
            }
            self.handleToolBarAction(action: action)
        }
        return bar
    }()
    
    override func initExample() {
        
        
        let xAxis = SCICategoryDateTimeAxis()
        xAxis.autoRange = .never
        xAxis.axisId = "xID"
        
        let yAxis = SCINumericAxis()
        yAxis.axisId = "yID"
        yAxis.autoRange = .always
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(30), max: SCIGeneric(37))
        
        let dataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .float)
        
        let marketDataService = MarketDataService(start: Date(), timeFrameMinutes: 5, tickTimerIntervals: 0.005)
        let data = marketDataService!.getHistoricalData(200)
        
        dataSeries.appendRangeX(SCIGeneric(data!.dateData()), open: SCIGeneric(data!.openData()), high: SCIGeneric(data!.highData()), low: SCIGeneric(data!.lowData()), close: SCIGeneric(data!.closeData()), count: data!.size())
        
        let rSeries = SCIFastCandlestickRenderableSeries()
        rSeries.xAxisId = "xID"
        rSeries.yAxisId = "yID"
        rSeries.dataSeries = dataSeries
        
        surface.xAxes.add(xAxis)
        surface.yAxes.add(yAxis)
        surface.renderableSeries.add(rSeries)
        surface.chartModifiers.add(SCIZoomPanModifier())
        
        SCIThemeManager.applyDefaultTheme(toThemeable: rSeries)
        
        setupSubviews()
    }
    
   
}


extension AnnotationBug {
    private func setupSubviews() {
        self.addSubview(toolBar)
        var safeAreaInsetsBottom: CGFloat = 0
        if #available(iOS 11.0, *) {
            safeAreaInsetsBottom = self.safeAreaInsets.bottom
        }
        toolBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(53 + safeAreaInsetsBottom)
        }
    }
    
    func handleToolBarAction(action: EditToolBarItemTypeEnum)  {
        switch action {
        case .line:
            self.addLineAnnotation()
        case .text:
            self.addTextAnnotation(text: "123213")
        case .delete(let isEnabled):
            if isEnabled {
                self.deleteSelectAnnotation()
            }
        default:
            break
        }
    }
}

// MARK: - Annotatin Operation
extension AnnotationBug {
    func addLineAnnotation() {
        let (x1, y1, x2, y2) = linePointForStyle(lineStyle: lineStyle)
        switch lineStyle {
        case .horizotal:
            createHorizontalAnnotation(x1: x1, y1: y1)
        case .vertical:
            createVerticalAnnotation(x1: x1, y1: y1)
        default:
            createSlashLineAnnotation(x1: x1, y1: y1, x2: x2, y2: y2)
        }
        
    }
    
    /// 文字标注
    func addTextAnnotation(text: String) {
        let chartSize = self.surface.renderSurfaceSizeView.frame.size
        let point = CGPoint(x: chartSize.width * 0.5, y: chartSize.height * 0.5)
        let (x1, y1) = iOSPointToSCIAxisPoint(point)
        let textAnnotation = FXTextAnnotation()
        textAnnotation.isEditable = true
        textAnnotation.editableText = false
        textAnnotation.selectableText = false
        textAnnotation.coordinateMode = .absolute
        textAnnotation.yAxisId = "yID"
        textAnnotation.xAxisId = "xID"
        textAnnotation.x1 = x1
        textAnnotation.y1 = y1
        textAnnotation.text = text
        textAnnotation.horizontalAnchorPoint = .center
        textAnnotation.verticalAnchorPoint = .center
        textAnnotation.style.textColor = self.colorStyle.color()
        textAnnotation.style.textStyle.fontSize = 11
        let name = self.createUUID()
        textAnnotation.annotationName = name
        
        self.surface.annotations.add(textAnnotation)
        
        textAnnotation.selectHandler = { [weak self] (annotation, isSelected) in
            guard let self = self, let textAnnotation = annotation  as? FXTextAnnotation  else {
                return
            }
            self.onAnnotationSelect(sender: textAnnotation, isSelected: isSelected)
        }
        textAnnotation.updateHandler = { [weak self] (annotation) in
            guard let self = self, let textAnnotation = annotation  as? FXTextAnnotation, let text = textAnnotation.text, let name = textAnnotation.annotationName else {
                return
            }
//            self.updateTextAnnotationContent?(text, name)
        }
        textAnnotation.isSelected = true
    }
    
    /// 添加水平线段标注
    private func createHorizontalAnnotation(x1: SCIGenericType, y1: SCIGenericType) {
        let horizontalLine = FXHorizontalLineAnnotation()
        horizontalLine.isEditable = true
        horizontalLine.coordinateMode = .absolute
        horizontalLine.yAxisId = "yID"
        horizontalLine.xAxisId = "xID"
        horizontalLine.x1 = x1
        horizontalLine.y1 = y1
        horizontalLine.style.resizeRadius = 44
        horizontalLine.style.selectRadius = 44
        horizontalLine.horizontalAlignment = .stretch
        horizontalLine.style.linePen = SCISolidPenStyle(color: self.colorStyle.color(), withThickness: 1.0)
        horizontalLine.style.resizeMarker.setPointMarkerColor(self.colorStyle.color(alpha: 0.2))
        horizontalLine.style.resizeMarker.strokeStyle = .none
        let name = self.createUUID()
        horizontalLine.annotationName = name
        
        self.surface.annotations.add(horizontalLine)
        
        horizontalLine.selectedActionHandler = { [weak self] (annotation, isSelected) in
            self?.onAnnotationSelect(sender: annotation, isSelected: isSelected)
        }
        horizontalLine.isSelected = true
    }
    
    /// 添加垂直线段标注
    private func createVerticalAnnotation(x1: SCIGenericType, y1: SCIGenericType) {
        let verticalLine = FXVerticalLineAnnotation()
        verticalLine.isEditable = true
        verticalLine.coordinateMode = .absolute
        verticalLine.xAxisId = "xID"
        verticalLine.x1 = x1
        verticalLine.y1 = y1
        verticalLine.verticalAlignment = .stretch
        verticalLine.style.linePen = SCISolidPenStyle(color: self.colorStyle.color(), withThickness: 1.0)
        verticalLine.style.resizeMarker.setPointMarkerColor(self.colorStyle.color(alpha: 0.2))
        verticalLine.style.resizeMarker.strokeStyle = .none
        verticalLine.style.selectRadius = 44
        verticalLine.style.resizeRadius = 44
        let name = self.createUUID()
        verticalLine.annotationName = name
        
        self.surface.annotations.add(verticalLine)
        
        verticalLine.selectedActionHandler = { [weak self] (annotation, isSelected) in
            self?.onAnnotationSelect(sender: annotation, isSelected: isSelected)
        }
        verticalLine.isSelected = true
        
    }
    
    /// 添加斜线
    private func createSlashLineAnnotation(x1: SCIGenericType, y1: SCIGenericType, x2: SCIGenericType, y2: SCIGenericType) {
        let slashLine = FXLineAnnotation()
        slashLine.coordinateMode = .absolute
        slashLine.yAxisId = "yID"
        slashLine.xAxisId = "xID"
        slashLine.x1 = x1
        slashLine.y1 = y1
        slashLine.x2 = x2
        slashLine.y2 = y2
        slashLine.isEditable = true
        slashLine.style.linePen = SCISolidPenStyle(color: self.colorStyle.color(), withThickness: 1.0)
        slashLine.style.resizeMarker.setPointMarkerColor(self.colorStyle.color(alpha: 0.2))
        slashLine.style.resizeMarker.strokeStyle = .none
        slashLine.style.selectRadius = 44
        slashLine.style.resizeRadius = 44
        let name = self.createUUID()
        slashLine.annotationName = name
        
        self.surface.annotations.add(slashLine)
        
        slashLine.selectedActionHandler = { [weak self] (annotation, isSelected) in
            self?.onAnnotationSelect(sender: annotation, isSelected: isSelected)
        }
        slashLine.isSelected = true
    }
    
    func deleteSelectAnnotation() {
        if let annotation = self.getSelectAnnotation() {
           let result = self.surface.annotations.remove(annotation)
        }
    }
    

}

// MARK: - Assistant
extension AnnotationBug {
    
    func linePointForStyle(lineStyle: ForexLineStyle) -> (SCIGenericType, SCIGenericType, SCIGenericType, SCIGenericType) {
        let size = self.surface.renderSurfaceSizeView.frame.size
        var startPoint: CGPoint = .zero
        var endPoint: CGPoint = .zero
        switch lineStyle {
        case .horizotal:
            startPoint = CGPoint(x: 0, y: size.height * 0.5)
            endPoint = CGPoint(x: size.width, y: size.height * 0.5)
        case .vertical:
            startPoint = CGPoint(x: size.width * 0.5, y: size.height)
            endPoint = CGPoint(x: size.width * 0.5, y: 0)
        default:
            startPoint = CGPoint(x: 100 , y: size.height - 50)
            endPoint = CGPoint(x: size.width - 100 , y: 50)
        }
        let (x1, y1) = iOSPointToSCIAxisPoint(startPoint)
        let (x2, y2) = iOSPointToSCIAxisPoint(endPoint)
        return (x1, y1, x2, y2)
    }
    
    func iOSPointToSCIAxisPoint(_ location: CGPoint) -> (SCIGenericType, SCIGenericType) {
        // X
        var sciX = SCIGeneric(0)
        let series = surface.renderableSeries
        let actualLocation : CGPoint = surface.renderSurface!.point(inChartFrame: location)
        // check every renderable series for hit
        for  i in 0 ..< series.count() {
            let rSeries : SCIRenderableSeriesProtocol! = series.item(at: UInt32(i))
            let data = rSeries.currentRenderPassData
            // get hit test tools
            if let hitTest = rSeries.hitTestProvider() {
                // hit test verticaly: check if vertical projection through touch location crosses chart
                let hitTestResult = hitTest.hitTestVerticalAt(x: Double(actualLocation.x),
                                                              y: Double(actualLocation.y),
                                                              radius: 5,
                                                              onData: data)
                sciX = hitTestResult.xValue
            }
        }
        
        //
        let y = (Double(surface.renderSurfaceSizeView.frame.height) - Double(actualLocation.y)) / Double(surface.renderSurfaceSizeView.frame.height)
        let yAxis = surface.yAxes.getAxisById("yID")
        let visibleRange = yAxis?.visibleRange
        var sciY = SCIGeneric(0)
        if let minValue = visibleRange?.min.doubleData, let maxValue = visibleRange?.max.doubleData {
            let gap = maxValue - minValue
            let curValue = minValue + gap * y
            sciY = SCIGeneric(curValue)
        }
        
        return (sciX, sciY)
    }
    
   
    private func createUUID() -> String {
        return UUID().uuidString.lowercased()
    }
    
    private func getSelectAnnotation() -> SCIAnnotationProtocol? {
        let count = UInt32(self.surface.annotations.count())
        for i in 0..<count {
            if let annotation = self.surface.annotations[i] as? SCIAnnotationBase  {
                let isSelect = annotation.isSelected
                if isSelect {
                    return annotation
                }
            }
        }
        return nil
    }
    
    private func onAnnotationSelect(sender: SCIAnnotationProtocol, isSelected: Bool) {
        guard let surface = self.surface else {
            return
        }
        var hasSelectedItem = false
        let count = UInt32(surface.annotations.count())
        for i in 0..<count {
            if let annotation = self.surface.annotations[i] as? SCIAnnotationBase  {
                if annotation.isSelected {
                    hasSelectedItem = true
                }
               
            }
        }
        
        if hasSelectedItem {
            self.toolBar.changeDeleteEnabled(isEnabled: true)
        }
        
    }
}
