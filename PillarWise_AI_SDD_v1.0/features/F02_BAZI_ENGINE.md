# F02. BaZi Engine

## 1. 目标

实现确定性的 BaZi/Four Pillars 计算与现代洞察映射。LLM 不参与计算。

## 2. 依赖策略

首版后端推荐使用 `cn.6tail:lunar` Java 库作为底层日历与八字计算基础，因为它支持公历、农历、干支、节气、八字、五行、十神等能力。

必须包装为接口：

```java
public interface BaziEngine {
  BaziChart calculate(BirthProfile profile);
}
```

实现：

```java
public class LunarJavaBaziEngine implements BaziEngine {}
```

不要让业务层直接依赖第三方库对象。

## 3. 输入

```java
public record BirthData(
  LocalDate birthDate,
  LocalTime birthTime,
  BirthTimePrecision birthTimePrecision,
  String birthPlaceText,
  Double latitude,
  Double longitude,
  ZoneId timezone,
  SexForTraditionalCycle sexForTraditionalCycle,
  boolean trueSolarTimeEnabled
) {}
```

## 4. 输出模型

```java
public record BaziChart(
  String chartId,
  String calcVersion,
  FourPillars fourPillars,
  String dayMaster,
  ElementDistribution elementDistribution,
  Map<String, Object> tenGods,
  Map<String, Object> hiddenStems,
  List<LuckCycle> luckCycles,
  List<AnnualCycle> annualCycles,
  ChartConfidence confidence
) {}
```

## 5. 计算要求

### 5.1 Year pillar

- 以节气立春为年柱切换基准。
- 不以农历正月初一作为默认。
- 如果库支持流派配置，使用“立春交接时刻”。

### 5.2 Month pillar

- 以节令切月，不以农历月份。
- 寅月从立春开始。
- 卯月从惊蛰开始。
- 后续依次按节气切换。

### 5.3 Day pillar

- 使用库计算。
- 必须写 golden tests 对照至少 20 个样例。

### 5.4 Hour pillar

- 使用当地出生时间。
- 如果 `trueSolarTimeEnabled=true` 且经纬度存在，先做真太阳时校正。
- 如果出生时间 unknown，hour pillar 为空，confidence.birthTime=unknown。

### 5.5 True solar time

简化实现要求：

```text
longitude offset minutes = (longitude - timezoneCentralMeridian) * 4
```

timezoneCentralMeridian：

```text
UTC offset hours * 15 degrees
```

首版可不做 equation of time 精修，但必须在 `calcVersion` 中标记。

如果 latitude/longitude 缺失：

- 不做真太阳时。
- confidence.location=approximate。

### 5.6 Luck cycles

如果 sexForTraditionalCycle 缺失或 prefer_not_to_say：

- 返回空或 general phase。
- confidence.timeline=low。

如果提供：

- 使用库计算大运。
- 返回未来/过去若干 cycle。

## 6. Element mapping

天干五行：

```text
Jia/Yi    Wood
Bing/Ding Fire
Wu/Ji     Earth
Geng/Xin  Metal
Ren/Gui   Water
```

地支主气：

```text
Zi Water
Chou Earth
Yin Wood
Mao Wood
Chen Earth
Si Fire
Wu Fire
Wei Earth
Shen Metal
You Metal
Xu Earth
Hai Water
```

Hidden stems 也参与 element distribution。

首版 distribution 可采用权重：

```text
heavenly stem visible = 1.0
branch main qi = 0.8
hidden stems = 0.3 each
seasonal month boost = 0.5 for month branch element
```

最后归一化为 0–1。

## 7. Archetype mapping

根据 dayMaster + element balance 输出 core archetype。

示例：

| Day Master | Balance signal | Archetype |
|---|---|---|
| Jia Wood | Wood high | The Vision Builder |
| Yi Wood | Wood/Water balanced | The Adaptive Creator |
| Bing Fire | Fire high | The Radiant Catalyst |
| Ding Fire | Fire moderate | The Quiet Illuminator |
| Wu Earth | Earth high | The Steady Mountain |
| Ji Earth | Earth balanced | The Grounded Strategist |
| Geng Metal | Metal high | The Principled Architect |
| Xin Metal | Metal balanced | The Refined Editor |
| Ren Water | Water high | The Deep Explorer |
| Gui Water | Water balanced | The Intuitive Synthesizer |

## 8. InsightMapper

`InsightMapper` 把 chart 转成现代结构：

```java
public record MappedInsight(
  String coreArchetype,
  List<String> strengths,
  List<String> blindSpots,
  String relationshipPattern,
  String careerStyle,
  String moneyStyle,
  String currentPhase
) {}
```

### 8.1 Strength examples

Earth high：

```text
Creates stability under pressure
Turns vague ideas into structure
Reliable when others feel scattered
```

Wood high：

```text
Sees growth potential quickly
Pushes toward improvement
Strong long-range vision
```

Fire high：

```text
Brings warmth and visibility
Motivates others through expression
Needs meaning and recognition
```

Metal high：

```text
Sharp standards and boundaries
Good at refining messy systems
Values clarity and integrity
```

Water high：

```text
Intuitive and adaptive
Comfortable with complexity
Learns through observation and reflection
```

## 9. Confidence model

```json
{
  "birthTime": "exact|approximate|unknown",
  "location": "exact|approximate|unknown",
  "timeline": "high|medium|low",
  "notes": ["Birth time is unknown, so hour-based insights are generalized."]
}
```

前端必须展示低置信度说明。

## 10. Golden tests

必须创建：

```text
backend/src/test/resources/bazi_golden_cases.json
```

每个 case：

```json
{
  "name": "case_001",
  "birthDate": "1994-08-21",
  "birthTime": "14:30",
  "timezone": "America/Los_Angeles",
  "latitude": 34.0522,
  "longitude": -118.2437,
  "expected": {
    "yearPillar": "...",
    "monthPillar": "...",
    "dayPillar": "...",
    "hourPillar": "..."
  }
}
```

Codex 若无法自动得到权威样例，先写 5 个由库自身稳定输出的 regression tests，再留 `TODO_GOLDEN_VERIFICATION.md` 说明需要人工与权威工具交叉验证。不可让测试缺失。

## 11. API

- `GET /api/v1/bazi/charts/{birthProfileId}`

## 12. Acceptance Criteria

- 同一 birth profile 多次计算结果一致。
- birth time unknown 不报错。
- location missing 不报错，但 confidence 降级。
- 所有 chart 保存 calcVersion。
- API 不返回第三方库内部对象。
- LLM 不参与 chart 计算。
